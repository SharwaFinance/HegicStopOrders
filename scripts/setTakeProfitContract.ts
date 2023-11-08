import {ethers, deployments} from "hardhat"
import {Signer} from "ethers"
import {solidity} from "ethereum-waffle"
import chai from "chai"
import { TakeProfit } from "../typechain-types"
import { UpkeepTakeProfit } from "../typechain-types"

const hre = require("hardhat");

chai.use(solidity)
const {expect} = chai

async function main() {
    const {deploy, get, execute} = deployments

    const [
      deployer
    ] = await hre.ethers.getSigners()

    const upkeepTakeProfit = (await hre.ethers.getContract("UpkeepTakeProfit")) as UpkeepTakeProfit
    const takeProfit = (await hre.ethers.getContract("TakeProfit")) as TakeProfit

    await upkeepTakeProfit.setTakeProfit(await takeProfit.getAddress())
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
