const hre = require("hardhat");

async function main() {

  const [deployer] = await hre.ethers.getSigners();
  console.log("Deploying with account:", deployer.address);

  const balance = await hre.ethers.provider.getBalance(deployer.address);
  console.log("Account balance:", hre.ethers.formatEther(balance), "ETH");

  const minBalance = hre.ethers.parseEther("0.001");
  if (balance < minBalance) {
    throw new Error(
      `Insufficient funds for deployment: need >= ${hre.ethers.formatEther(minBalance)} ETH in ${deployer.address}. Fund the account (Sepolia faucet) or use a different key.`
    );
  }

  const Token = await hre.ethers.getContractFactory("ERC20MintBurn");

  const token = await Token.deploy(
    "MintBurnToken",
    "MBT",
    1_000_000
  );

  await token.waitForDeployment();

  console.log("ERC20MintBurn deployed to:", await token.getAddress());
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
