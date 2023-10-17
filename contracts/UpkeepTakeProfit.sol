// SPDX-License-Identifier: MIT
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

    function setTakePprofit(ITakeProfit newTakeProfit) external onlyOwner {
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
