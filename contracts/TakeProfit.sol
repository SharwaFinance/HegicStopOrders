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

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {IOperationalTreasury, IHegicStrategy} from "./IOperationalTreasury.sol";
import {ITakeProfit} from "./ITakeProfit.sol";
import {IPositionManager} from "./IPositionManager.sol";

/**
 * @title TakeProfit
 * @author 0nika0
 * @dev A contract that enables users to set and execute take-profit orders on ERC721 tokens.
 */
contract TakeProfit is ITakeProfit {

    IPositionManager public positionManager;
    IOperationalTreasury public operationalTreasury;

    mapping(uint256 => TakeInfo) public tokenIdToTakeInfo;

    constructor(
        address _positionManager, 
        address _operationalTreasury
    ) {
        positionManager = IPositionManager(_positionManager);
        operationalTreasury = IOperationalTreasury(_operationalTreasury);
    }

    // VIEW FUNCTIONS // 

    /**
     * @dev See {ITakeProfit-getPayOffAmount}.
     */
    function getPayOffAmount(uint256 tokenId) public view override returns (uint256) {
        (, IHegicStrategy strategy, , , ) = operationalTreasury.lockedLiquidity(tokenId);
        return strategy.payOffAmount(tokenId);
    } 

    /**
     * @dev See {ITakeProfit-getCurrentPrice}.
     */
    function getCurrentPrice(uint256 tokenId) public view override returns (uint256) {
        (, IHegicStrategy strategy, , , ) = operationalTreasury.lockedLiquidity(tokenId);
        (, int256 latestPrice, , , ) = AggregatorV3Interface(strategy.priceProvider()).latestRoundData();
        require(latestPrice != 0, "invalid price");
        return uint256(latestPrice);
    }

    /**
     * @dev See {ITakeProfit-getExpirationTime}.
     */
    function getExpirationTime(uint256 tokenId) public view override returns (uint256) {
        (, , , , uint32 expiration) = operationalTreasury.lockedLiquidity(tokenId);
        return uint256(expiration);
    }
    
    /**
     * @dev See {ITakeProfit-checkTakeProfit}.
     */
    function checkTakeProfit(uint256 tokenId) public view override returns (bool takeProfitTriggered) {
        TakeInfo memory takenInfo = tokenIdToTakeInfo[tokenId];

        if (takenInfo.expirationTime == 0 || block.timestamp < takenInfo.expirationTime) {
            return false;
        }

        uint256 timeToExpiration = takenInfo.expirationTime - block.timestamp;

        if (timeToExpiration < takenInfo.timeToExecution && getPayOffAmount(tokenId) > 0) {
            return true;
        }

        uint256 currentPrice = getCurrentPrice(takenInfo.tokenId);

        if (takenInfo.isTpPriceGte) {
            takeProfitTriggered = currentPrice >= takenInfo.tpPriceGte;
        } else if (takenInfo.isTpPriceLte) {
            takeProfitTriggered = currentPrice <= takenInfo.tpPriceLte;
        }
    }

    // EXTERANAL FUNCTIONS // 

    /**
     * @dev See {ITakeProfit-setTakeProfit}.
     */
    function setTakeProfit(
        uint256 tokenId,
        uint256 tpPriceGte,
        uint256 tpPriceLte,
        uint256 timeToExecution,
        bool isTpPriceGte,
        bool isTpPriceLte,
        address owner
    ) external override {
        require(positionManager.ownerOf(tokenId) == msg.sender, "Caller must be the owner of the token");

        require(positionManager.isApprovedOrOwner(address(this), tokenId), "This tokenId is not approved for this address");

        uint256 expirationTime = getExpirationTime(tokenId);

        require(block.timestamp < expirationTime, "Option expiration date has passed");

        tokenIdToTakeInfo[tokenId] = TakeInfo(
            tokenId,
            tpPriceGte,
            tpPriceLte,
            expirationTime,
            timeToExecution,
            owner,
            isTpPriceGte,
            isTpPriceLte
        );

        emit TakeProfitSet(
            tokenId, 
            tpPriceGte, 
            tpPriceLte,
            timeToExecution,
            isTpPriceGte,
            isTpPriceLte
        );
    }

    /**
     * @dev See {ITakeProfit-deleteTakeProfit}.
     */
    function deleteTakeProfit(uint256 tokenId) external override {
        TakeInfo memory takenInfo = tokenIdToTakeInfo[tokenId];
        
        require(positionManager.ownerOf(tokenId) == msg.sender, "Caller must be the owner of the token");

        require(takenInfo.expirationTime > 0, "No token set for take profit");

        delete tokenIdToTakeInfo[tokenId];

        positionManager.transferFrom(address(this), msg.sender, tokenId);

        emit TakeProfitDeleted(tokenId);
    }

    /**
     * @dev See {ITakeProfit-updateTakeProfit}.
     */
    function updateTakeProfit(
        uint256 tokenId,
        uint256 newTpPriceGte,
        uint256 newTpPriceLte,
        uint256 newTimeToExecution,
        bool newIsTpPriceGte,
        bool newIsTpPriceLte
    ) external override {
        TakeInfo storage takenInfo = tokenIdToTakeInfo[tokenId];

        require(positionManager.ownerOf(tokenId) == msg.sender, "Caller must be the owner of the token");

        require(takenInfo.expirationTime > 0, "No token set for take profit");

        require(block.timestamp < takenInfo.expirationTime, "Option expiration date has passed");

        takenInfo.tpPriceGte = newTpPriceGte;
        takenInfo.tpPriceLte = newTpPriceLte;
        takenInfo.timeToExecution = newTimeToExecution;
        takenInfo.isTpPriceGte = newIsTpPriceGte;
        takenInfo.isTpPriceLte = newIsTpPriceLte;

        emit TakeProfitUpdated(
            tokenId, 
            newTpPriceGte, 
            newTpPriceLte,
            newTimeToExecution,
            newIsTpPriceGte,
            newIsTpPriceLte
        );
    }

    /**
     * @dev See {ITakeProfit-executeTakeProfit}.
     */
    function executeTakeProfit(uint256 tokenId) external override {
        TakeInfo memory takenInfo = tokenIdToTakeInfo[tokenId];

        require(checkTakeProfit(tokenId), "Take profit conditions not met");

        delete tokenIdToTakeInfo[tokenId];

        positionManager.transferFrom(msg.sender, address(this), tokenId);

        if (block.timestamp < takenInfo.expirationTime) {
            payOff(takenInfo);
        }

        emit TakeProfitExecuted(tokenId);
    }

    // PRIVATE FUNCTIONS // 

    /**
     * @dev Pays off the profit to the owner of a token based on the provided TakeInfo.
     * 
     * This private function is used to pay off the profit to the owner of a token when the take profit
     * conditions have been met and the token has not yet expired. It interacts with the operational treasury
     * to calculate and transfer the profit.
     * 
     * @param takenInfo The TakeInfo structure containing information about the token and its take profit configuration.
     */
    function payOff(TakeInfo memory takenInfo) private {
        operationalTreasury.payOff(takenInfo.tokenId, takenInfo.owner);

        positionManager.transferFrom(address(this), takenInfo.owner, takenInfo.tokenId);
    }
}
