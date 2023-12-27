/**
 * SPDX-License-Identifier: GPL-3.0-or-later
 * Sharwa.Finance
 * Copyright (C) 2023 Sharwa.Finance
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/
pragma solidity 0.8.0;
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ITakeProfit} from "./ITakeProfit.sol";
import {IPositionsManager} from "./IPositionsManager.sol";
import {ILinkTokenInterface} from "./ILinkTokenInterface.sol";
import {IClonableBeaconProxy} from "./IClonableBeaconProxy.sol";

contract UpkeepBalances is 
    AutomationCompatibleInterface,
    Ownable
{
    uint256 public minBalance = 25e18;
    uint256 public provideAmount = 5e18;
    ILinkTokenInterface public link;
    IClonableBeaconProxy public beacon;

    mapping(uint256 => uint256) public indexToUpkeepIds;
    uint256 public nextIndex;

    constructor(
        ILinkTokenInterface _link,
        IClonableBeaconProxy _beacon
    ) {
        link = _link;
        beacon = _beacon;
    }

    // OWNER FUNCTIONS //

    function addUpkeepId(uint256 id) external onlyOwner {
        indexToUpkeepIds[nextIndex] = id;
        nextIndex++;
    }

    function setUpkeepId(uint256 id, uint256 index) external onlyOwner {
        indexToUpkeepIds[index] = id;
    }

    function withdraw(uint256 amount) external onlyOwner {
        link.transfer(msg.sender, amount);
    }

    function setProvideAmount(uint256 newProvideAmount) external onlyOwner {
        provideAmount = newProvideAmount;
    }

    function setMinBalance(uint256 newMinBalance) external onlyOwner {
        minBalance = newMinBalance;
    }

    function setBeacon(IClonableBeaconProxy newBeacon) external onlyOwner {
        beacon = newBeacon;
    }

    function allApprove(uint256 amount) external {
        link.approve(address(beacon), amount);
    }


    // VIEW FUNCTIONS //

    function getUpkeepBalance(uint256 id) public view returns(uint256 balance) {
        IClonableBeaconProxy.UpkeepInfo memory upkeepData = beacon.getUpkeep(id);
        balance = uint256(upkeepData.balance);
    }

    // EXTERNAL FUNCTIONS // 

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        upkeepNeeded = false;
        for (uint256 i = 0; i < nextIndex; i++) {
            if (indexToUpkeepIds[i] != 0) {
                if (getUpkeepBalance(indexToUpkeepIds[i]) < minBalance) {
                    upkeepNeeded = true;
                    performData = abi.encode(indexToUpkeepIds[i]);
                    break;
                }
            }
        }
        return (upkeepNeeded, performData);
    }

    function performUpkeep(bytes calldata performData) external override {
        (uint256 id) = abi.decode(
            performData,
            (uint256)
        );
        if (getUpkeepBalance(id) < minBalance) {
            link.transferAndCall(
                address(beacon),
                provideAmount,
                abi.encode(id)
            );
        }
    }
}