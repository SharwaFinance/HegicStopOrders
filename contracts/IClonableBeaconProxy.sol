pragma solidity 0.8.0;

interface IClonableBeaconProxy {

    struct UpkeepInfo {
        address target;
        uint32 executeGas;
        bytes checkData;
        uint96 balance;
        address admin;
        uint64 maxValidBlocknumber;
        uint32 lastPerformBlockNumber;
        uint96 amountSpent;
        bool paused;
        bytes offchainConfig;
    }

    function getUpkeep(uint256 id) external view returns (UpkeepInfo memory upkeepInfo);
}