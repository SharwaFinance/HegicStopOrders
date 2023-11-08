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

    await takeProfit.setGlobalTimeToExecution(60*30)

    console.log(await takeProfit.checkTakeProfit(7453))

    // console.log(await takeProfit.tokenIdToTakeInfo(7402))

//     console.log(await takeProfit.getCurrentPrice(7420))

//     console.log(await takeProfit.getPayOffAmount(7420))

//     console.log(await takeProfit.getExpirationTime(7420))

//     console.log(await positionManager.isApprovedOrOwner(await takeProfit.getAddress(), 7420))
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
