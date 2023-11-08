import {ethers, deployments} from "hardhat"
import {Signer} from "ethers"
import {solidity} from "ethereum-waffle"
import chai from "chai"
import { UpkeepBalances } from "../typechain-types"
import { ERC20 } from "../typechain-types"
import { UpkeepTakeProfit } from "../typechain-types"

const hre = require("hardhat");

chai.use(solidity)
const {expect} = chai

async function main() {
    const {deploy, get, execute} = deployments

    const [
      deployer
    ] = await hre.ethers.getSigners()

    const UpkeepBalances = (await hre.ethers.getContract("UpkeepBalances")) as UpkeepBalances
    const UpkeepTakeProfit = (await hre.ethers.getContract("UpkeepTakeProfit")) as UpkeepTakeProfit
    const LINK = (await hre.ethers.getContract("LINK")) as ERC20

    // await LINK.transfer(await UpkeepBalances.getAddress(), BigInt(2e18))

    // await UpkeepBalances.withdraw(BigInt(2e18))
    // await UpkeepBalances.allApprove(BigInt(2e18))
    
    // await UpkeepBalances.addUpkeepId(71811323549820858690788095236248551462108397831996880708762786105308124610685n);

    // console.log("UpkeepBalances: ", (await LINK.balanceOf(await UpkeepBalances.getAddress())).toString(), "LINK")
    const up = await UpkeepTakeProfit.checkUpkeep("0x000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000fa")
    console.log(up)
    // console.log(await UpkeepBalances.checkUpkeep("0x"))
    // const tx = await UpkeepTakeProfit.performUpkeep("0x0000000000000000000000000000000000000000000000000000000000001cfc")
    // console.log(tx)

    // console.log("UpkeepTakeProfit.takeProfit:", await UpkeepTakeProfit.takeProfit())
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
