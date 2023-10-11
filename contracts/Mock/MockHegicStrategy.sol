// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../IHegicStrategy.sol";

contract MockHegicStrategy is IHegicStrategy {
    address public mockPriceProvider;
    mapping(uint256 => uint256) private payOffAmounts;

    constructor(address _mockPriceProvider) {
        mockPriceProvider = _mockPriceProvider;
    }

    function setPayOffAmount(uint256 optionID, uint256 amount) external {
        payOffAmounts[optionID] = amount;
    }

    function priceProvider() external view override returns (address) {
        return mockPriceProvider;
    }

    function payOffAmount(uint256 optionID) external view override returns (uint256) {
        return payOffAmounts[optionID];
    }
}