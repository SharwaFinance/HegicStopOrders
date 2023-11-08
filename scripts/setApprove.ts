import {ethers, deployments} from "hardhat"
import {Signer} from "ethers"
import {solidity} from "ethereum-waffle"
import chai from "chai"
import { TakeProfit } from "../typechain-types"
import { IPositionManager } from "../typechain-types/contracts/IPositionManager"
import { IERC721 } from "../typechain-types"

const hre = require("hardhat");

chai.use(solidity)
const {expect} = chai

async function main() {
    const {deploy, get, execute} = deployments

    const [
      deployer, alice
    ] = await hre.ethers.getSigners()

    const positionManager = (await hre.ethers.getContract("PositionsManager")) as IERC721
    const takeProfit = (await hre.ethers.getContract("TakeProfit")) as TakeProfit

    // await positionManager.approve(await takeProfit.getAddress(), 7414)
    // await positionManager.connect(alice).transferFrom(alice.address, deployer.address, 7402)
    await positionManager.transferFrom(deployer.address, alice.address, 7453)
    console.log(await positionManager.ownerOf(7453))
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
