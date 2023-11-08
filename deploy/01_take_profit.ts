import {HardhatRuntimeEnvironment} from "hardhat/types"

async function deployment(hre: HardhatRuntimeEnvironment): Promise<void> {
  const {deployments, getNamedAccounts, network} = hre
  const {deploy, get, save, getArtifact} = deployments
  const {deployer} = await getNamedAccounts()

  const OperationalTreasury = await get("OperationalTreasury")
  const PositionsManager = await get("PositionsManager")

  await deploy("TakeProfit", {
    from: deployer,
    log: true,
    args: [PositionsManager.address, OperationalTreasury.address],
  })

}

deployment.tags = ["take_profit"]
deployment.dependencies = ["preparation"]

export default deployment
