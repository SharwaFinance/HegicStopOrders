import {HardhatRuntimeEnvironment} from "hardhat/types"

async function deployment(hre: HardhatRuntimeEnvironment): Promise<void> {
  const {deployments, getNamedAccounts, network} = hre
  const {deploy, save, getArtifact} = deployments
  const {deployer} = await getNamedAccounts()


  if (network.name == "hardhat") {
    await deploy("USDC", {
      contract: "MockERC20",
      from: deployer,
      log: true,
      args: ["USDC (Mock)", "USDC", 6],
    })

    const PriceProviderUSDC = await deploy("PriceProviderUSDC", {
      contract: "MockAggregatorV3",
      from: deployer,
      log: true,
      args: [8],
    })

    const MockHegicStrategy = await deploy("HegicStrategy", {
      contract: "MockHegicStrategy",
      from: deployer,
      args: [PriceProviderUSDC.address]
    })

    await deploy("PositionsManager", {
      contract: "MockPositionsManager", 
      from: deployer,
      args: []
    })

    await deploy("OperationalTreasury", {
      contract: "MockOperationalTreasury",
      from: deployer,
      args: [MockHegicStrategy.address]
    })    
  } 
  // else if (network.name == "arb_ddl")

}

deployment.tags = ["preparation"]
export default deployment
