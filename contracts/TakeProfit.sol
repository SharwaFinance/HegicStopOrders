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

pragma solidity ^0.8.0;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IOperationalTreasury, IHegicStrategy} from "./IOperationalTreasury.sol";
import {ITakeProfit} from "./ITakeProfit.sol";
import {IPositionsManager} from "./IPositionsManager.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title TakeProfit
 * @author 0nika0
 * @dev A contract that enables users to set and execute take-profit orders on ERC721 tokens.
 */
contract TakeProfit is ITakeProfit, Ownable {

    IPositionsManager public positionManager;
    IOperationalTreasury public operationalTreasury;

    uint256 public globalTimeToExecution = 30 minutes;

    mapping(uint256 => TakeInfo) public tokenIdToTakeInfo;

    constructor(
        address _positionManager, 
        address _operationalTreasury
    ) {
        positionManager = IPositionsManager(_positionManager);
        operationalTreasury = IOperationalTreasury(_operationalTreasury);
    }

    // OWNER FUNCTIONS //

    function setGlobalTimeToExecution(uint256 newGlobalTimeToExecution) external override onlyOwner {
        globalTimeToExecution = newGlobalTimeToExecution;
    }

    // VIEW FUNCTIONS // 

    function getPayOffAmount(uint256 tokenId) public view override returns (uint256) {
        (, IHegicStrategy strategy, , , ) = operationalTreasury.lockedLiquidity(tokenId);
        return strategy.payOffAmount(tokenId);
    } 

    function getCurrentPrice(uint256 tokenId) public view override returns (uint256) {
        (, IHegicStrategy strategy, , , ) = operationalTreasury.lockedLiquidity(tokenId);
        (, int256 latestPrice, , , ) = AggregatorV3Interface(strategy.priceProvider()).latestRoundData();
        require(latestPrice != 0, "invalid price");
        return uint256(latestPrice);
    }

    function getExpirationTime(uint256 tokenId) public view override returns (uint256) {
        (, , , , uint32 expiration) = operationalTreasury.lockedLiquidity(tokenId);
        return uint256(expiration);
    }

    function isOptionActive(uint256 tokenId) public view override returns (bool) {
        (IOperationalTreasury.LockedLiquidityState state, , , , ) = operationalTreasury.lockedLiquidity(tokenId);
        return state == IOperationalTreasury.LockedLiquidityState.Locked;
    }
    
    function checkTakeProfit(uint256 tokenId) public view override returns (bool takeProfitTriggered) {
        TakeInfo memory takenInfo = tokenIdToTakeInfo[tokenId];

        if (!(positionManager.isApprovedOrOwner(address(this), tokenId) && getPayOffAmount(tokenId) > 0 && isOptionActive(tokenId))) {
            return false;
        }

        if (block.timestamp > getExpirationTime(tokenId) - globalTimeToExecution) {
            return true;
        }

        uint256 currentPrice = getCurrentPrice(tokenId);

        return takenInfo.upperStopPrice != 0 && currentPrice >= takenInfo.upperStopPrice ||
                    takenInfo.lowerStopPrice != 0 && currentPrice <= takenInfo.lowerStopPrice;
    }

    // EXTERANAL FUNCTIONS // 

    function setTakeProfit(uint256 tokenId, TakeInfo calldata takeProfitParams) external override {
        require(positionManager.ownerOf(tokenId) == msg.sender, "Caller must be the owner of the token");

        require(block.timestamp < getExpirationTime(tokenId), "Option expiration date has passed");

        tokenIdToTakeInfo[tokenId] = TakeInfo(
            takeProfitParams.upperStopPrice,
            takeProfitParams.lowerStopPrice
        );

        emit TakeProfitSet(
            tokenId, 
            msg.sender,
            takeProfitParams.upperStopPrice,
            takeProfitParams.lowerStopPrice
        );
    }

    function deleteTakeProfit(uint256 tokenId) external override {
        TakeInfo memory takenInfo = tokenIdToTakeInfo[tokenId];
        
        require(positionManager.ownerOf(tokenId) == msg.sender, "Caller must be the owner of the token");

        require((takenInfo.upperStopPrice == 0 && takenInfo.lowerStopPrice == 0) == false, "No token set for take profit");

        delete tokenIdToTakeInfo[tokenId];

        emit TakeProfitDeleted(tokenId);
    }

    function executeTakeProfit(uint256 tokenId) external override {
        require(checkTakeProfit(tokenId), "Take profit conditions not met");

        delete tokenIdToTakeInfo[tokenId];

        address tokenOwner = positionManager.ownerOf(tokenId); 

        operationalTreasury.payOff(tokenId, tokenOwner);

        emit TakeProfitExecuted(tokenId, tokenOwner);
    }
}
