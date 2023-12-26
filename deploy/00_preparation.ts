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

  } else {
    save("USDCe", {
      address: "0xFF970A61A04b1cA14834A43f5dE4533eBDDB5CC8",
      abi: await getArtifact("@openzeppelin/contracts/token/ERC20/ERC20.sol:ERC20").then((x) => x.abi),
    })

    save("LINK", {
      address: "0xf97f4df75117a78c1A5a0DBb814Af92458539FB4",
      abi: await getArtifact("@openzeppelin/contracts/token/ERC20/ERC20.sol:ERC20").then((x) => x.abi),
    })

    save("IClonableBeaconProxy", {
      address: "0x37D9dC70bfcd8BC77Ec2858836B923c560E891D1",
      abi: await getArtifact("contracts/IClonableBeaconProxy.sol:IClonableBeaconProxy").then((x) => x.abi),
    })

    save("PositionsManager", {
      address: "0x5Fe380D68fEe022d8acd42dc4D36FbfB249a76d5",
      abi: await getArtifact("contracts/IPositionsManager.sol:IPositionsManager").then((x) => x.abi),
    })

    save("OperationalTreasury", {
      address: "0xec096ea6eB9aa5ea689b0CF00882366E92377371",
      abi: await getArtifact("contracts/IOperationalTreasury.sol:IOperationalTreasury").then((x) => x.abi),
    })
  }

}

deployment.tags = ["preparation"]
export default deployment
