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

interface IChainlinkMiddleware {

    /**
     * @dev Sets a take profit configuration for a specific tokenized option and transfers the token to the contract.
     * 
     * This function allows a user to set a take profit configuration for a tokenized option. It checks if the active take profit count
     * is within the maximum limit, and if so, it adds the token to the active list and transfers ownership of the token to the contract.
     * After that, it invokes the `setTakeProfit` function of the `takeProfit` contract to set the take profit conditions.
     * Finally, it transfers the token back to the original owner.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being set.
     * @param tpPriceGte The take profit price condition (greater than or equal to).
     * @param tpPriceLte The take profit price condition (less than or equal to).
     * @param timeToExecution The time duration before the take profit is executed.
     * @param isTpPriceGte Boolean indicating if the take profit condition is "greater than or equal to."
     * @param isTpPriceLte Boolean indicating if the take profit condition is "less than or equal to."
     * 
     * Requirements:
     * - The active take profit count must be less than the maximum allowed (`maxActiveTakes`).
     */
    function setTakeProfit(
        uint256 tokenId,
        uint256 tpPriceGte,
        uint256 tpPriceLte,
        uint256 timeToExecution,
        bool isTpPriceGte,
        bool isTpPriceLte
    ) external;

    /**
     * @dev Deletes the take profit configuration for a specific tokenized option and transfers the token to the contract.
     * 
     * This function allows a user to delete the take profit configuration for a tokenized option. It removes the token from the
     * active list, transfers ownership of the token to the contract, invokes the `deleteTakeProfit` function of the `takeProfit`
     * contract to delete the take profit configuration, and then transfers the token back to the original owner.
     * 
     * @param tokenId The unique identifier of the token for which the take profit configuration is being deleted.
     * 
     * Requirements:
     * - The caller must be the owner of the specified token.
     */
    function deleteTakeProfit(uint256 tokenId) external;

    /**
     * @dev Executes the take profit conditions for a specific tokenized option and transfers the token to the contract.
     * 
     * This function allows a user to execute the take profit conditions for a tokenized option. It removes the token from the
     * active list, transfers ownership of the token to the contract, invokes the `executeTakeProfit` function of the `takeProfit`
     * contract to execute the take profit conditions, and then transfers the token back to the original owner.
     * 
     * @param tokenId The unique identifier of the token for which the take profit conditions are being executed.
     * 
     * Requirements:
     * - The take profit conditions must have been met for the specified token.
     */
    function executeTakeProfit(uint256 tokenId) external;
} 