// SPDX-License-Identifier: MIT
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