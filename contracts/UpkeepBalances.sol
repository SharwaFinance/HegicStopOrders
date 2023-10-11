// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;
import {AutomationCompatibleInterface} from "@chainlink/contracts/src/v0.8/automation/interfaces/AutomationCompatibleInterface.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ITakeProfit} from "./ITakeProfit.sol";
import {IPositionsManager} from "./IPositionsManager.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract UpkeepBalances is 
    AutomationCompatibleInterface,
    Ownable
{
    uint256 public minBalance = 25e18;
    uint256 public provideAmount = 5e18;
    IERC20 public token;
    address[] public addresses;

    constructor(
        IERC20 _token
    ) {
        token = _token;
    }

    // OWNER FUNCTIONS //

    function setAddress(address value, uint256 index) external onlyOwner {
        addresses[index] = value;
    }

    function withdraw(uint256 amount) external onlyOwner {
        token.transfer(msg.sender, amount);
    }

    function setProvideAmount(uint256 newProvideAmount) external onlyOwner {
        provideAmount = newProvideAmount;
    }

    function setMinBalance(uint256 newMinBalance) external onlyOwner {
        minBalance = newMinBalance;
    }

    // EXTERNAL FUNCTIONS // 

    function checkUpkeep(
        bytes calldata /* checkData */
    )
        external
        view
        override
        returns (bool upkeepNeeded, bytes memory performData)
    {
        upkeepNeeded = false;
        for (uint256 i = 0; i < addresses.length; i++) {
            if (token.balanceOf(addresses[i]) < minBalance) {
                upkeepNeeded = true;
                performData = abi.encode(addresses[i]);
                break;
            }
        }
        return (upkeepNeeded, performData);
    }

    function performUpkeep(bytes calldata performData) external override {
        (address account) = abi.decode(
            performData,
            (address)
        );
        if (token.balanceOf(account) < minBalance) {
            token.transfer(account, provideAmount);
        }
    }
}