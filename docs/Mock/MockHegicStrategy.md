# MockHegicStrategy









## Methods

### mockPriceProvider

```solidity
function mockPriceProvider() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### payOffAmount

```solidity
function payOffAmount(uint256 optionID) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| optionID | uint256 | The ID of the option. |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | The profit amount for the specified option. |

### priceProvider

```solidity
function priceProvider() external view returns (address)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | The address of the price provider. |

### setPayOffAmount

```solidity
function setPayOffAmount(uint256 optionID, uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| optionID | uint256 | undefined |
| amount | uint256 | undefined |




