import {HardhatRuntimeEnvironment} from "hardhat/types"

async function deployment(hre: HardhatRuntimeEnvironment): Promise<void> {
  const {deployments, getNamedAccounts, network} = hre
  const {deploy, get, save, getArtifact} = deployments
  const {deployer} = await getNamedAccounts()

  const TakeProfit = await get("TakeProfit")
  const PositionsManager = await get("PositionsManager")

  await deploy("UpkeepTakeProfit", {
      from: deployer,
      log: true,
      args: [TakeProfit.address, PositionsManager.address],
  })
    
  // TODO: change UpkeepBalances
}

deployment.tags = ["upkeep"]
deployment.dependencies = ["preparation", "take_profit"]

export default deployment
