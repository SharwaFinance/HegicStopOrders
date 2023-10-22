import {ethers, deployments} from "hardhat"
import {Signer} from "ethers"
import {solidity} from "ethereum-waffle"
import chai from "chai"
import { UpkeepBalances } from "../typechain-types"
import { ERC20 } from "../typechain-types"

const hre = require("hardhat");

chai.use(solidity)
const {expect} = chai

async function main() {
    const {deploy, get, execute} = deployments

    const [
      deployer
    ] = await hre.ethers.getSigners()

    const UpkeepBalances = (await hre.ethers.getContract("UpkeepBalances")) as UpkeepBalances
    const LINK = (await hre.ethers.getContract("LINK")) as ERC20

    // await LINK.transfer(await UpkeepBalances.getAddress(), BigInt(2e18))

    // await UpkeepBalances.withdraw(BigInt(2e18))
    // await UpkeepBalances.allApprove(BigInt(2e18))
    
    // await UpkeepBalances.addUpkeepId(71811323549820858690788095236248551462108397831996880708762786105308124610685n);

    console.log("UpkeepBalances: ", (await LINK.balanceOf(await UpkeepBalances.getAddress())).toString(), "LINK")
    // console.log(await UpkeepBalances.checkUpkeep("0x"))
    // console.log(await UpkeepBalances.performUpkeep("0x9ec3c4ce000000000000000000000000e138af5f971953bc255d0210a0f9007d"))
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
