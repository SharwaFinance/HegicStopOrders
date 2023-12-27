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

contract UpkeepTakeProfit is 
    AutomationCompatibleInterface, 
    Ownable
{
    ITakeProfit public takeProfit;
    IPositionsManager public positionsManager;

    constructor(
        ITakeProfit _takeProfit,
        IPositionsManager _positionsManager
    ) {
        takeProfit = _takeProfit;
        positionsManager = _positionsManager;
    }

    // OWNER FUNCTIONS //

    function setTakeProfit(ITakeProfit newTakeProfit) external onlyOwner {
        takeProfit = newTakeProfit;
    }

    function setPositionManager(IPositionsManager newPositionsManager) external onlyOwner {
        positionsManager = newPositionsManager;
    }

    // EXTERNAL FUNCTIONS // 

    function checkUpkeep(
        bytes calldata checkData
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        (uint256 lowerBound, uint256 upperBound) = abi.decode(
            checkData,
            (uint256, uint256)
        );

        uint256 lastTokenId = positionsManager.nextTokenId() - 1;

        uint256 start = lastTokenId - upperBound;
        uint256 end = lastTokenId - lowerBound;

        for (uint256 i = start; i <= end; i++) {
            if (takeProfit.checkTakeProfit(i)) {
                upkeepNeeded = true;
                performData = abi.encode(i);
                break;
            }
        }
        return (upkeepNeeded, performData);
    }

    function performUpkeep(bytes calldata performData) external override {
        (uint256 optionID) = abi.decode(
            performData,
            (uint256)
        );
        takeProfit.executeTakeProfit(optionID);
    }
}
