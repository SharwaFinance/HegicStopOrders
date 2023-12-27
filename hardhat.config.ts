import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import 'hardhat-deploy';
import 'hardhat-deploy-ethers';
import '@nomicfoundation/hardhat-ethers';
import "@keep-network/hardhat-local-networks-config";
import '@primitivefi/hardhat-dodoc';
import dotenv from "dotenv"

dotenv.config()

const config: HardhatUserConfig = {
  localNetworksConfig: "~/.hardhat/networks.json",
  solidity: "0.8.0",
  namedAccounts: {
    deployer: {
      default: 0,
    },
  },
  etherscan: {
    apiKey: process.env.ARBITRUM_API_KEY,
  },
};

export default config;
