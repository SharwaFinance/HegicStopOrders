# ITakeProfit









## Methods

### checkTakeProfit

```solidity
function checkTakeProfit(uint256 tokenId) external view returns (bool takeProfitTriggered)
```



*Checks if the take profit conditions for a specific token have been triggered. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the token for which take profit is being checked.  |

#### Returns

| Name | Type | Description |
|---|---|---|
| takeProfitTriggered | bool | Boolean indicating whether the take profit conditions have been triggered or not. |

### deleteTakeProfit

```solidity
function deleteTakeProfit(uint256 tokenId) external nonpayable
```



*Deletes the take profit configuration for a specific token.  This function allows the owner of a specified token to delete the associated take profit configuration. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the token for which the take profit is being deleted.  Requirements: - The caller must be the owner of the token. - A valid take profit configuration must exist for the token. |

### executeTakeProfit

```solidity
function executeTakeProfit(uint256 tokenId) external nonpayable
```



*Executes the take profit for a specific token.  This function allows a user to execute the take profit conditions for a specified token. If the take profit conditions are met, the associated action, such as transferring the token and potentially paying off the profit, is executed. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the token for which the take profit is being executed.  Requirements: - The take profit conditions must be met for the specified token. |

### getCurrentPrice

```solidity
function getCurrentPrice(uint256 tokenId) external view returns (uint256)
```



*Retrieves the current price for a specific token ID. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the token for which the current price is requested.  |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The current price for the specified token in the form of a uint256.  Requirements: - The price retrieved must not be zero, indicating a valid price. |

### getExpirationTime

```solidity
function getExpirationTime(uint256 tokenId) external view returns (uint256)
```



*Retrieves the expiration time for a specific token ID. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the token for which the expiration time is requested.  |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The expiration time for the specified token in the form of a uint256. |

### getPayOffAmount

```solidity
function getPayOffAmount(uint256 tokenId) external view returns (uint256)
```



*Retrieves the payoff amount for a specific token ID. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the token for which the payoff amount is requested.  |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The calculated payoff amount for the specified token. |

### isOptionActive

```solidity
function isOptionActive(uint256 tokenId) external view returns (bool)
```



*Checks whether a specific option with the given tokenId is currently active.  An active option means that it is in the &#39;Locked&#39; state within the operational treasury. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | The unique identifier of the option token being checked.  |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | A boolean value indicating whether the option is currently active (true) or not (false). |

### setGlobalTimeToExecution

```solidity
function setGlobalTimeToExecution(uint256 newGlobalTimeToExecution) external nonpayable
```



*Updates the global time to execution for all take profit orders.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newGlobalTimeToExecution | uint256 | The new global time duration, in seconds, before take profit orders are executed. Requirements: - Only the contract owner can set the new global time to execution. |

### setTakeProfit

```solidity
function setTakeProfit(uint256 tokenId, ITakeProfit.TakeInfo takeProfitParams) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| takeProfitParams | ITakeProfit.TakeInfo | undefined |



## Events

### TakeProfitDeleted

```solidity
event TakeProfitDeleted(uint256 indexed tokenId)
```



*An event emitted when a take profit configuration is deleted for a tokenized option.  This event is triggered when a user successfully deletes the take profit configuration for a specific tokenized option. It includes the unique identifier of the token for which the take profit configuration is deleted. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | The unique identifier of the token for which the take profit configuration is deleted. |

### TakeProfitExecuted

```solidity
event TakeProfitExecuted(uint256 indexed tokenId, address indexed user)
```



*An event emitted when a take profit is executed for a tokenized option.  This event is triggered when a take profit is successfully executed for a specific tokenized option. It includes the unique identifier of the token for which the take profit is executed. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | The unique identifier of the token for which the take profit is executed. |
| user `indexed` | address | The address of the user setting the take profit configuration. |

### TakeProfitSet

```solidity
event TakeProfitSet(uint256 indexed tokenId, address indexed user, uint256 upperStopPrice, uint256 lowerStopPrice)
```



*An event emitted when a take profit configuration is set for a tokenized option.  This event is triggered when a user successfully sets a take profit configuration for a specific tokenized option. It includes details such as the token&#39;s unique identifier, upper and lower stop price conditions,  which define the range for triggering the take profit, and indicate when the take profit conditions are met. *

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | The unique identifier of the token for which the take profit is being set. |
| user `indexed` | address | The address of the user setting the take profit configuration. |
| upperStopPrice  | uint256 | The upper stop price condition for take profit (greater than or equal to). |
| lowerStopPrice  | uint256 | The lower stop price condition for take profit (less than or equal to). |



