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

interface ITakeProfit {
    // STRUCTS //

    /**
     * @dev A structure representing the take profit configuration for a tokenized option.
     * 
     * This structure contains information about the take profit settings for a specific tokenized option.
     * It includes the token's unique identifier, take profit price conditions (greater than or equal to and less than or equal to),
     * expiration time, time duration before execution, owner's address, and boolean flags indicating the take profit conditions.
     */
    struct TakeInfo {
        uint256 tokenId;            // The unique identifier of the token.
        uint256 tpPriceGte;         // The take profit price condition (greater than or equal to).
        uint256 tpPriceLte;         // The take profit price condition (less than or equal to).
        uint256 expirationTime;     // The expiration time of the tokenized option.
        uint256 timeToExecution;    // The time duration before the take profit is executed.
        address owner;              // The owner's address of the token.
        bool isTpPriceGte;          // Boolean indicating if the take profit condition is "greater than or equal to."
        bool isTpPriceLte;          // Boolean indicating if the take profit condition is "less than or equal to."
    }

    // VIEW FUNCTIONS //

    /**
     * @dev Retrieves the payoff amount for a specific token ID.
     * 
     * @param tokenId The unique identifier of the token for which the payoff amount is requested.
     * 
     * @return The calculated payoff amount for the specified token.
     */
    function getPayOffAmount(uint256 tokenId) external view returns (uint256);

    /**
     * @dev Retrieves the current price for a specific token ID.
     * 
     * @param tokenId The unique identifier of the token for which the current price is requested.
     * 
     * @return The current price for the specified token in the form of a uint256.
     * 
     * Requirements:
     * - The price retrieved must not be zero, indicating a valid price.
     */
    function getCurrentPrice(uint256 tokenId) external view returns (uint256);

    /**
     * @dev Retrieves the expiration time for a specific token ID.
     * 
     * @param tokenId The unique identifier of the token for which the expiration time is requested.
     * 
     * @return The expiration time for the specified token in the form of a uint256.
     */
    function getExpirationTime(uint256 tokenId) external view returns (uint256);

    /**
     * @dev Checks if the take profit conditions for a specific token have been triggered.
     * 
     * This function allows for the evaluation of whether the take profit conditions have been met
     * for a particular token, considering factors such as expiration time, time to execution, and price conditions.
     * 
     * @param tokenId The unique identifier of the token for which take profit is being checked.
     * 
     * @return takeProfitTriggered Boolean indicating whether the take profit conditions have been triggered or not.
     */
    function checkTakeProfit(uint256 tokenId) external view returns (bool takeProfitTriggered);

    // EXTERNAL FUNCTIONS //

    /**
     * @dev Sets a take profit configuration for a specific token.
     * 
     * This function allows the specified owner to set a take profit configuration for a particular token,
     * including price conditions, execution time, and conditions for greater than or less than comparisons.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being set.
     * @param tpPriceGte The take profit price (greater than or equal to condition).
     * @param tpPriceLte The take profit price (less than or equal to condition).
     * @param timeToExecution The time duration before the take profit is executed.
     * @param isTpPriceGte Boolean indicating if the take profit condition is "greater than or equal to."
     * @param isTpPriceLte Boolean indicating if the take profit condition is "less than or equal to."
     * @param owner The address of the owner of the token.
     * 
     * Requirements:
     * - The caller must be the owner of the specified token.
     * - The contract must be approved to manage the specified token.
     * - The option expiration date must not have passed.
     */
    function setTakeProfit(
        uint256 tokenId,
        uint256 tpPriceGte,
        uint256 tpPriceLte,
        uint256 timeToExecution,
        bool isTpPriceGte,
        bool isTpPriceLte,
        address owner
    ) external;

    /**
     * @dev Deletes the take profit configuration for a specific token.
     * 
     * This function allows the owner of a specified token to delete the associated take profit configuration.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being deleted.
     * 
     * Requirements:
     * - The caller must be the owner of the specified token.
     * - A valid take profit configuration must exist for the token.
     */
    function deleteTakeProfit(uint256 tokenId) external;

    /**
     * @dev Updates the take profit configuration for a specific token.
     * 
     * This function allows the owner of a specified token to update the existing take profit parameters,
     * including price conditions, execution time, and conditions for greater than or less than comparisons.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being updated.
     * @param newTpPriceGte The new take profit price (greater than or equal to condition).
     * @param newTpPriceLte The new take profit price (less than or equal to condition).
     * @param newTimeToExecution The new time duration before the take profit is executed.
     * @param newIsTpPriceGte Boolean indicating the new take profit condition "greater than or equal to."
     * @param newIsTpPriceLte Boolean indicating the new take profit condition "less than or equal to."
     * 
     * Requirements:
     * - The caller must be the owner of the specified token.
     * - A valid take profit configuration must exist for the token.
     * - The option expiration date must not have passed.
     */
    function updateTakeProfit(
        uint256 tokenId,
        uint256 newTpPriceGte,
        uint256 newTpPriceLte,
        uint256 newTimeToExecution,
        bool newIsTpPriceGte,
        bool newIsTpPriceLte
    ) external;

    /**
     * @dev Executes the take profit for a specific token.
     * 
     * This function allows a user to execute the take profit conditions for a specified token.
     * If the take profit conditions are met, the associated action, such as transferring the token and
     * potentially paying off the profit, is executed.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being executed.
     * 
     * Requirements:
     * - The take profit conditions must be met for the specified token.
     */
    function executeTakeProfit(uint256 tokenId) external;

    // EVENTS // 

    /**
     * @dev An event emitted when a take profit configuration is set for a tokenized option.
     * 
     * This event is triggered when a user successfully sets a take profit configuration for a specific tokenized option.
     * It includes details such as the token's unique identifier, take profit price conditions (greater than or equal to and less than or equal to),
     * time duration before execution, and boolean flags indicating the take profit conditions.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being set.
     * @param tpPriceGte The take profit price condition (greater than or equal to).
     * @param tpPriceLte The take profit price condition (less than or equal to).
     * @param timeToExecution The time duration before the take profit is executed.
     * @param isTpPriceGte Boolean indicating if the take profit condition is "greater than or equal to."
     * @param isTpPriceLte Boolean indicating if the take profit condition is "less than or equal to."
     */
    event TakeProfitSet(
        uint256 indexed tokenId, 
        uint256 tpPriceGte,
        uint256 tpPriceLte,
        uint256 timeToExecution,
        bool isTpPriceGte,
        bool isTpPriceLte
    );

    /**
     * @dev An event emitted when a take profit configuration is updated for a tokenized option.
     * 
     * This event is triggered when a user successfully updates the take profit configuration for a specific tokenized option.
     * It includes details such as the token's unique identifier, updated take profit price conditions (greater than or equal to and less than or equal to),
     * updated time duration before execution, and boolean flags indicating the updated take profit conditions.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is being updated.
     * @param tpPriceGte The updated take profit price condition (greater than or equal to).
     * @param tpPriceLte The updated take profit price condition (less than or equal to).
     * @param timeToExecution The updated time duration before the take profit is executed.
     * @param isTpPriceGte Boolean indicating if the updated take profit condition is "greater than or equal to."
     * @param isTpPriceLte Boolean indicating if the updated take profit condition is "less than or equal to."
     */
    event TakeProfitUpdated(
        uint256 indexed tokenId, 
        uint256 tpPriceGte,
        uint256 tpPriceLte,
        uint256 timeToExecution,
        bool isTpPriceGte,
        bool isTpPriceLte
    );
    
    /**
     * @dev An event emitted when a take profit configuration is deleted for a tokenized option.
     * 
     * This event is triggered when a user successfully deletes the take profit configuration for a specific tokenized option.
     * It includes the unique identifier of the token for which the take profit configuration is deleted.
     * 
     * @param tokenId The unique identifier of the token for which the take profit configuration is deleted.
     */
    event TakeProfitDeleted(uint256 indexed tokenId);
    
    /**
     * @dev An event emitted when a take profit is executed for a tokenized option.
     * 
     * This event is triggered when a take profit is successfully executed for a specific tokenized option.
     * It includes the unique identifier of the token for which the take profit is executed.
     * 
     * @param tokenId The unique identifier of the token for which the take profit is executed.
     */
    event TakeProfitExecuted(uint256 indexed tokenId);
}