# IOperationalTreasury









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

### payOff

```solidity
function payOff(uint256 positionID, address account) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| positionID | uint256 | The position ID to pay off. |
| account | address | The address to receive the pay off. |




