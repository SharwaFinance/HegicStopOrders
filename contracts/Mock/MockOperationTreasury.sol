// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import { IHegicStrategy } from "../IHegicStrategy.sol";
import { IOperationalTreasury } from "../IOperationalTreasury.sol";

contract MockOperationalTreasury is IOperationalTreasury {
    struct LockedLiquidity {
        LockedLiquidityState state;
        uint128 negativepnl;
        uint128 positivepnl;
        uint32 expiration;
    }

    IHegicStrategy public theOnlyStrategy;

    mapping(uint256 => LockedLiquidity) public lockedLiquidityData;

    constructor(
        IHegicStrategy _theOnlyStrategy
    ) {
        theOnlyStrategy = _theOnlyStrategy;
    }

    function payOff(uint256 positionID, address account) external override {}

    function lockedLiquidity(uint256 id)
        external
        override
        view
        returns (
            LockedLiquidityState state,
            IHegicStrategy strategy,
            uint128 negativepnl,
            uint128 positivepnl,
            uint32 expiration
        )
    {
        LockedLiquidity memory lockedLiquidity = lockedLiquidityData[id];
        state = lockedLiquidity.state;
        strategy = theOnlyStrategy;
        negativepnl = lockedLiquidity.negativepnl;
        positivepnl = lockedLiquidity.positivepnl;
        expiration = lockedLiquidity.expiration;
    }

    function setLockedLiquidity(
        uint256 id,
        uint256 period,
        LockedLiquidityState state
    ) external {
        LockedLiquidity storage lockedLiquidity = lockedLiquidityData[id];
        lockedLiquidity.expiration = uint32(block.timestamp + period);
        lockedLiquidity.state = state;
    }
}
