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

import {ITakeProfit} from "./ITakeProfit.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IChainlinkMiddleware} from "./IChainlinkMiddleware.sol";

contract ChainlinkMiddleware is Ownable, IChainlinkMiddleware { 

    ITakeProfit public takeProfit;
    IERC721 public erc721Contract;

    uint256 public activeTakeCount;
    uint256 public maxActiveTakes = 1000;

    mapping(uint256 => uint256) public indexTokenToTokenId;
    mapping(uint256 => uint256) public idTokenToIndexToken;
    mapping(uint256 => address) public idTokenToOwner;

    constructor(
        address _takeProfit,
        address _erc721Address
    ) {
        takeProfit = ITakeProfit(_takeProfit);
        erc721Contract = IERC721(_erc721Address);
    }

    // ONLY OWNER //

    /**
     * @dev Sets the maximum number of active takes for managing the option.
     * 
     * @param newMaxActiveTakes The new maximum number of active takes to be set.
     * 
     * Requirements:
     * - Only the owner of the contract can call this function.
     */
    function setMaxActiveTakes(uint256 newMaxActiveTakes) external onlyOwner {
        maxActiveTakes = newMaxActiveTakes;
    }

    // EXTERANAL FUNCTIONS // 

    /**
     * @dev See {IChainlinkMiddleware-setTakeProfit}.
     */
    function setTakeProfit(
        uint256 tokenId,
        uint256 tpPriceGte,
        uint256 tpPriceLte,
        uint256 timeToExecution,
        bool isTpPriceGte,
        bool isTpPriceLte
    ) external override {
        require(activeTakeCount < maxActiveTakes, "active take limit exceeded");
        
        activeTakeCount++;
        indexTokenToTokenId[activeTakeCount] = tokenId;
        idTokenToIndexToken[tokenId] = activeTakeCount;
        idTokenToOwner[tokenId] = msg.sender;

        erc721Contract.transferFrom(msg.sender, address(this), tokenId);

        takeProfit.setTakeProfit(
            tokenId,
            tpPriceGte,
            tpPriceLte,
            timeToExecution,
            isTpPriceGte,
            isTpPriceLte, 
            msg.sender
        );

        erc721Contract.transferFrom(address(this), msg.sender, tokenId);
    }

    /**
     * @dev See {IChainlinkMiddleware-deleteTakeProfit}.
     */
    function deleteTakeProfit(uint256 tokenId) external override {
        _removeTokenFromActiveList(tokenId);

        erc721Contract.transferFrom(msg.sender, address(this), tokenId);

        takeProfit.deleteTakeProfit(tokenId);

        erc721Contract.transferFrom(address(this), msg.sender, tokenId);
    }

    /**
     * @dev See {IChainlinkMiddleware-executeTakeProfit}.
     */
    function executeTakeProfit(uint256 tokenId) external override {
        _removeTokenFromActiveList(tokenId);

        erc721Contract.transferFrom(idTokenToOwner[tokenId], address(this), tokenId);

        takeProfit.executeTakeProfit(tokenId);

        erc721Contract.transferFrom(address(this), idTokenToOwner[tokenId], tokenId);
    }

    // PRIVATE FUNCTIONS // 
    
    /**
     * @dev This function removes a token from the active list of take profits, 
     * moves the last token to the position of the removed one, 
     * and updates the indices to manage the active take profits.
     */
    function _removeTokenFromActiveList(uint256 tokenId) private {
        uint256 indexToRemove = idTokenToIndexToken[tokenId];
        uint256 lastTokenId = indexTokenToTokenId[activeTakeCount];

        indexTokenToTokenId[indexToRemove] = lastTokenId;
        idTokenToIndexToken[lastTokenId] = indexToRemove;

        delete indexTokenToTokenId[activeTakeCount];
        delete idTokenToIndexToken[tokenId];
        activeTakeCount--;
    }

}