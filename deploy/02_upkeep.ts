import {HardhatRuntimeEnvironment} from "hardhat/types"

async function deployment(hre: HardhatRuntimeEnvironment): Promise<void> {
  const {deployments, getNamedAccounts, network} = hre
  const {deploy, get, save, getArtifact} = deployments
  const {deployer} = await getNamedAccounts()

  const TakeProfit = await get("TakeProfit")
  const PositionsManager = await get("PositionsManager")
  const LINK = await get("LINK")
  const IClonableBeaconProxy = await get("IClonableBeaconProxy")

  // await deploy("UpkeepTakeProfit", {
  //     from: deployer,
  //     log: true,
  //     args: [TakeProfit.address, PositionsManager.address],
  // })
    
  await deploy("UpkeepBalances", {
      from: deployer,
      log: true,
      args: [LINK.address, IClonableBeaconProxy.address],
  })
}

deployment.tags = ["upkeep"]
deployment.dependencies = ["preparation", "take_profit"]

export default deployment
