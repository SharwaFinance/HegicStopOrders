# HegicStopOrders Documentation

HegicStopOrders is a system that allows users to delegate the execution of option positions. Users delegate the right to execute their options, and when trigger conditions are met, the options become available for exercising (closing).

## Features

### Functionality:

1. Automatically execute the option when time conditions are met.
2. Automatically execute the option when price conditions are met.

### Examples
For example, if you buy a Call option with a strike price of $1,000, you can set up a stop market order with a trigger price of $1,100. When the trigger condition is met, the option can be exercised (closed).

HegicStopOrders uses Chainlink Automation to check the conditions of all active stop orders. When the trigger conditions are met, Chainlink Automation calls the specified function that exercises the option.

HegicStopOrders also uses Chainlink Price Oracles to determine if the price trigger condition is met.

Another functionality involves time-based triggers. You can set up a time trigger, and the positions will be closed when the trigger condition is met. For example, you can set a condition that your position should be exercised one hour before the expiration date. When the time conditions are met, Chainlink Automation will call the specified function to exercise the position.


## Support

If you have questions about how to use the SDK, please reach out in the `#dev-chat` channel in our Discord.

## Initialization

```shell
yarn build

yarn clean

yarn test
```
