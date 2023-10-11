import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'hardhat-deploy';
import 'hardhat-deploy-ethers';
import '@nomicfoundation/hardhat-ethers';

const config: HardhatUserConfig = {
  solidity: "0.8.0",
  namedAccounts: {
    deployer: {
        default: 0,
    },
},
};

export default config;
