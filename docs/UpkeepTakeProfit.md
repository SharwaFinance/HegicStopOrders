# UpkeepTakeProfit









## Methods

### checkUpkeep

```solidity
function checkUpkeep(bytes checkData) external view returns (bool upkeepNeeded, bytes performData)
```

method that is simulated by the keepers to see if any work actually needs to be performed. This method does does not actually need to be executable, and since it is only ever simulated it can consume lots of gas.

*To ensure that it is never called, you may want to add the cannotExecute modifier from KeeperBase to your implementation of this method.*

#### Parameters

| Name | Type | Description |
|---|---|---|
| checkData | bytes | specified in the upkeep registration so it is always the same for a registered upkeep. This can easily be broken down into specific arguments using `abi.decode`, so multiple upkeeps can be registered on the same contract and easily differentiated by the contract. |

#### Returns

| Name | Type | Description |
|---|---|---|
| upkeepNeeded | bool | boolean to indicate whether the keeper should call performUpkeep or not. |
| performData | bytes | bytes that the keeper should call performUpkeep with, if upkeep is needed. If you would like to encode data to decode later, try `abi.encode`. |

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

### positionsManager

```solidity
function positionsManager() external view returns (contract IPositionsManager)
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


### setPositionManager

```solidity
function setPositionManager(contract IPositionsManager newPositionsManager) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newPositionsManager | contract IPositionsManager | undefined |

### setTakeProfit

```solidity
function setTakeProfit(contract ITakeProfit newTakeProfit) external nonpayable
```





#### Parameters

| Name | Type | Description |
|---|---|---|
| newTakeProfit | contract ITakeProfit | undefined |

### takeProfit

```solidity
function takeProfit() external view returns (contract ITakeProfit)
```






#### Returns

| Name | Type | Description |
|---|---|---|
| _0 | contract ITakeProfit | undefined |

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



