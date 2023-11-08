import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'hardhat-deploy';
import 'hardhat-deploy-ethers';
import '@nomicfoundation/hardhat-ethers';
import "@keep-network/hardhat-local-networks-config";

const config: HardhatUserConfig = {
  localNetworksConfitg: "~/.hardhat/config.json",
  solidity: "0.8.0",
  namedAccounts: {
    deployer: {
      default: 0,
    },
},
};

export default config;
