# UpkeepBalances









## Methods

### addUpkeepId

```solidity
function addUpkeepId(uint256 id) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint256 | undefined |

### allApprove

```solidity
function allApprove(uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |

### beacon

```solidity
function beacon() external view returns (contract IClonableBeaconProxy)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract IClonableBeaconProxy | undefined |

### checkUpkeep

```solidity
function checkUpkeep(bytes) external view returns (bool upkeepNeeded, bytes performData)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | bytes | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| upkeepNeeded | bool | undefined |
| performData | bytes | undefined |

### getUpkeepBalance

```solidity
function getUpkeepBalance(uint256 id) external view returns (uint256 balance)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| balance | uint256 | undefined |

### indexToUpkeepIds

```solidity
function indexToUpkeepIds(uint256) external view returns (uint256)
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### link

```solidity
function link() external view returns (contract ILinkTokenInterface)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ILinkTokenInterface | undefined |

### minBalance

```solidity
function minBalance() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### nextIndex

```solidity
function nextIndex() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### owner

```solidity
function owner() external view returns (address)
```



*Returns the address of the current owner.*


#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | address | undefined |

### performUpkeep

```solidity
function performUpkeep(bytes performData) external nonpayable
```

method that is actually executed by the keepers, via the registry. The data returned by the checkUpkeep simulation will be passed into this method to actually be executed.

*The input to this method should not be trusted, and the caller of the method should not even be restricted to any single registry. Anyone should be able call it, and the input should be validated, there is no guarantee that the data passed in is the performData returned from checkUpkeep. This could happen due to malicious keepers, racing keepers, or simply a state change while the performUpkeep transaction is waiting for confirmation. Always validate the data passed in.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| performData | bytes | is the data which was passed back from the checkData simulation. If it is encoded, it can easily be decoded into other types by calling `abi.decode`. This data should not be trusted, and should be validated against the contract&#39;s current state. |

### provideAmount

```solidity
function provideAmount() external view returns (uint256)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | uint256 | undefined |

### renounceOwnership

```solidity
function renounceOwnership() external nonpayable
```



*Leaves the contract without owner. It will not be possible to call `onlyOwner` functions. Can only be called by the current owner. NOTE: Renouncing ownership will leave the contract without an owner, thereby disabling any functionality that is only available to the owner.*


### setBeacon

```solidity
function setBeacon(contract IClonableBeaconProxy newBeacon) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newBeacon | contract IClonableBeaconProxy | undefined |

### setMinBalance

```solidity
function setMinBalance(uint256 newMinBalance) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newMinBalance | uint256 | undefined |

### setProvideAmount

```solidity
function setProvideAmount(uint256 newProvideAmount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newProvideAmount | uint256 | undefined |

### setUpkeepId

```solidity
function setUpkeepId(uint256 id, uint256 index) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| id | uint256 | undefined |
| index | uint256 | undefined |

### transferOwnership

```solidity
function transferOwnership(address newOwner) external nonpayable
```



*Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| newOwner | address | undefined |

### withdraw

```solidity
function withdraw(uint256 amount) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| amount | uint256 | undefined |



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



