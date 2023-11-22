# TakeProfit

*0nika0*

> TakeProfit



*A contract that enables users to set and execute take-profit orders on ERC721 tokens.*

## Methods

### checkTakeProfit

```solidity
function checkTakeProfit(uint256 tokenId) external view returns (bool takeProfitTriggered)
```



*See {ITakeProfit-checkTakeProfit}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| takeProfitTriggered | bool | undefined |

### deleteTakeProfit

```solidity
function deleteTakeProfit(uint256 tokenId) external nonpayable
```



*See {ITakeProfit-deleteTakeProfit}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### executeTakeProfit

```solidity
function executeTakeProfit(uint256 tokenId) external nonpayable
```



*See {ITakeProfit-executeTakeProfit}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

### getCurrentPrice

```solidity
function getCurrentPrice(uint256 tokenId) external view returns (uint256)
```



*See {ITakeProfit-getCurrentPrice}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getExpirationTime

```solidity
function getExpirationTime(uint256 tokenId) external view returns (uint256)
```



*See {ITakeProfit-getExpirationTime}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### getPayOffAmount

```solidity
function getPayOffAmount(uint256 tokenId) external view returns (uint256)
```



*See {ITakeProfit-getPayOffAmount}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### globalTimeToExecution

```solidity
function globalTimeToExecution() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### isOptionActive

```solidity
function isOptionActive(uint256 tokenId) external view returns (bool)
```



*See {ITakeProfit-isOptionActive}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | bool | undefined |

### operationalTreasury

```solidity
function operationalTreasury() external view returns (contract IOperationalTreasury)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IOperationalTreasury | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### positionManager

```solidity
function positionManager() external view returns (contract IPositionsManager)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IPositionsManager | undefined |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby disabling any functionality that is only available to the owner.*


### setGlobalTimeToExecution

```solidity
function setGlobalTimeToExecution(uint256 newGlobalTimeToExecution) external nonpayable
```



*See {ITakeProfit-setGlobalTimeToExecution}.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newGlobalTimeToExecution | uint256 | undefined |

### setTakeProfit

```solidity
function setTakeProfit(uint256 tokenId, ITakeProfit.TakeInfo takeProfitParams) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId | uint256 | undefined |
| takeProfitParams | ITakeProfit.TakeInfo | undefined |

### tokenIdToTakeInfo

```solidity
function tokenIdToTakeInfo(uint256) external view returns (uint256 upperStopPrice, uint256 lowerStopPrice)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| upperStopPrice | uint256 | undefined |
| lowerStopPrice | uint256 | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |



## Events

### OwnershipTransferred

```solidity
event OwnershipTransferred(address indexed previousOwner, address indexed newOwner)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| previousOwner `indexed` | address | undefined |
| newOwner `indexed` | address | undefined |

### TakeProfitDeleted

```solidity
event TakeProfitDeleted(uint256 indexed tokenId)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | undefined |

### TakeProfitExecuted

```solidity
event TakeProfitExecuted(uint256 indexed tokenId, address indexed user)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | undefined |
| user `indexed` | address | undefined |

### TakeProfitSet

```solidity
event TakeProfitSet(uint256 indexed tokenId, address indexed user, uint256 upperStopPrice, uint256 lowerStopPrice)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| tokenId `indexed` | uint256 | undefined |
| user `indexed` | address | undefined |
| upperStopPrice  | uint256 | undefined |
| lowerStopPrice  | uint256 | undefined |



