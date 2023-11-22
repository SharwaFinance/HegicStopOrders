# MockOperationalTreasury









## Methods

### lockedLiquidity

```solidity
function lockedLiquidity(uint256 id) external view returns (enum IOperationalTreasury.LockedLiquidityState state, contract IHegicStrategy strategy, uint128 negativepnl, uint128 positivepnl, uint32 expiration)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint256 | The locked liquidity ID. |

#### Returns

| Name | Type | Description |
|---|---|---|
| state | enum IOperationalTreasury.LockedLiquidityState | The state of the locked liquidity. |
| strategy | contract IHegicStrategy | The strategy associated with the locked liquidity. |
| negativepnl | uint128 | The negative profit and loss value. |
| positivepnl | uint128 | The positive profit and loss value. |
| expiration | uint32 | The expiration time of the locked liquidity. |

### lockedLiquidityData

```solidity
function lockedLiquidityData(uint256) external view returns (enum IOperationalTreasury.LockedLiquidityState state, uint128 negativepnl, uint128 positivepnl, uint32 expiration)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| state | enum IOperationalTreasury.LockedLiquidityState | undefined |
| negativepnl | uint128 | undefined |
| positivepnl | uint128 | undefined |
| expiration | uint32 | undefined |

### payOff

```solidity
function payOff(uint256 positionID, address account) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| positionID | uint256 | The position ID to pay off. |
| account | address | The address to receive the pay off. |

### setLockedLiquidity

```solidity
function setLockedLiquidity(uint256 id, uint256 period, enum IOperationalTreasury.LockedLiquidityState state) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint256 | undefined |
| period | uint256 | undefined |
| state | enum IOperationalTreasury.LockedLiquidityState | undefined |

### theOnlyStrategy

```solidity
function theOnlyStrategy() external view returns (contract IHegicStrategy)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IHegicStrategy | undefined |




