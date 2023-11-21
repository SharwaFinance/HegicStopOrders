import { expect } from "chai";
import { ethers, deployments } from "hardhat";
import { TakeProfit } from "../typechain-types";
import { Signer } from "ethers";
import { MockPositionsManager } from "../typechain-types";
import { MockOperationalTreasury } from "../typechain-types";
import { MockHegicStrategy } from "../typechain-types";
import { MockAggregatorV3 } from "../typechain-types";

describe("TAKE_PROFIT.spec.ts", function () {
  let takeProfit: TakeProfit
  let positionsManager: MockPositionsManager
  let operationalTreasury: MockOperationalTreasury
  let hegicStrategy: MockHegicStrategy
  let priceProviderUSDC: MockAggregatorV3
  let signers: Signer[]

  let tokenId = 1;
  const upperStopPrice = 2000e8;
  const lowerStopPrice = 1000e8;

  beforeEach(async () => {
    await deployments.fixture(["take_profit"])

    takeProfit = await ethers.getContract("TakeProfit")
    positionsManager = await ethers.getContract("PositionsManager")
    operationalTreasury = await ethers.getContract("OperationalTreasury")
    hegicStrategy = await ethers.getContract("HegicStrategy")
    priceProviderUSDC = await ethers.getContract("PriceProviderUSDC")
    signers = await ethers.getSigners()

    await priceProviderUSDC.setAnswer(1500e8)

    await positionsManager.mint(signers[0])
    await positionsManager.setApprovalForAll(await takeProfit.getAddress(), true)

    await operationalTreasury.setLockedLiquidity(tokenId, 60*60*24*7, 1)

  });

  it("should set and get globalTimeToExecution", async () => {
    const newGlobalTimeToExecution = 60 * 60;

    await takeProfit.setGlobalTimeToExecution(newGlobalTimeToExecution);

    const updatedGlobalTimeToExecution = await takeProfit.globalTimeToExecution();
    expect(updatedGlobalTimeToExecution).to.equal(newGlobalTimeToExecution);
  });

  it("should set and get take profit parameters", async () => {
    await takeProfit.setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });

    const takeProfitInfo = await takeProfit.tokenIdToTakeInfo(tokenId);
    expect(takeProfitInfo.upperStopPrice).to.equal(upperStopPrice);
    expect(takeProfitInfo.lowerStopPrice).to.equal(lowerStopPrice);
  });

  it("should delete take profit parameters", async () => {
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });
    await takeProfit.connect(signers[0]).deleteTakeProfit(tokenId);

    const takeProfitInfo = await takeProfit.tokenIdToTakeInfo(tokenId);
    expect(takeProfitInfo.upperStopPrice).to.equal(0);
    expect(takeProfitInfo.lowerStopPrice).to.equal(0);
  });

  it("should update take profit parameters", async () => {
    const newUpperStopPrice = 2500e8;
    const newLowerStopPrice = 1500e8;

    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice: upperStopPrice, lowerStopPrice: lowerStopPrice });
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice: newUpperStopPrice, lowerStopPrice: newLowerStopPrice });

    const takeProfitInfo = await takeProfit.tokenIdToTakeInfo(tokenId);
    expect(takeProfitInfo.upperStopPrice).to.equal(newUpperStopPrice);
    expect(takeProfitInfo.lowerStopPrice).to.equal(newLowerStopPrice);
  });

  it("should execute take profit", async () => {
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });

    await priceProviderUSDC.setAnswer(1000e8)
    await hegicStrategy.setPayOffAmount(tokenId, 1)

    await takeProfit.executeTakeProfit(tokenId);

    const takeProfitInfo = await takeProfit.tokenIdToTakeInfo(tokenId);
    expect(takeProfitInfo.upperStopPrice).to.equal(0);
    expect(takeProfitInfo.lowerStopPrice).to.equal(0);
  });

  it("should check take profit conditions", async () => {
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });

    let takeProfitTriggered = await takeProfit.checkTakeProfit(tokenId);
    expect(takeProfitTriggered).to.equal(false);

    await priceProviderUSDC.setAnswer(1000e8)
    await hegicStrategy.setPayOffAmount(tokenId, 100)

    takeProfitTriggered = await takeProfit.checkTakeProfit(tokenId);
    expect(takeProfitTriggered).to.equal(true);
  });

  it("should not execute take profit if conditions not met", async () => {
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });

    await expect(takeProfit.executeTakeProfit(tokenId)).to.be.revertedWith("Take profit conditions not met");
  });

  it("should not set take profit for expired option", async () => {
    await ethers.provider.send("evm_increaseTime", [60*60*24*7+1])

    await expect(takeProfit.setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice })).to.be.revertedWith("Option expiration date has passed");
  });

  it("should revert when executing take profit if conditions not met", async () => {
    await expect(takeProfit.connect(signers[0]).executeTakeProfit(tokenId)).to.be.revertedWith("Take profit conditions not met");
  });
  
  it("should revert when set take profit if not the owner", async () => {
    await expect(takeProfit.connect(signers[1]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice })).to.be.revertedWith("Caller must be the owner of the token");
  });

  it("should revert when deleting take profit parameters if not the owner", async () => {
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });

    await expect(takeProfit.connect(signers[1]).deleteTakeProfit(tokenId)).to.be.revertedWith("Caller must be the owner of the token");
  });

  it("should revert when updating take profit parameters if not the owner", async () => {
    await takeProfit.connect(signers[0]).setTakeProfit(tokenId, { upperStopPrice, lowerStopPrice });

    await expect(takeProfit.connect(signers[1]).setTakeProfit(tokenId, { upperStopPrice: 2500e8, lowerStopPrice: 1500e8 })).to.be.revertedWith("Caller must be the owner of the token");
  });

});