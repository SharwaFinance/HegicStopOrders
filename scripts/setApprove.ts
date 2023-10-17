import {ethers, deployments} from "hardhat"
import {Signer} from "ethers"
import {solidity} from "ethereum-waffle"
import chai from "chai"
import { TakeProfit } from "../typechain-types"
import { IPositionManager } from "../typechain-types/contracts/IPositionManager"

const hre = require("hardhat");

chai.use(solidity)
const {expect} = chai

async function main() {
    const {deploy, get, execute} = deployments

    const [
      deployer
    ] = await hre.ethers.getSigners()

    const positionManager = (await hre.ethers.getContract("PositionsManager")) as IPositionManager
    const takeProfit = (await hre.ethers.getContract("TakeProfit")) as TakeProfit

    await positionManager.approve(await takeProfit.getAddress(), 7216)
 }

main()
  .then(() => {
	console.log("success")
	process.exit(0)
})
  .catch(e => {
	console.error(e)
	process.exit(1)
  })
