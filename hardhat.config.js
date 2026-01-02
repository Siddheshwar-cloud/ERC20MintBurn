require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

const { SEPOLIA_URL, SEPOLIA_RPC_URL, PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;

const networks = {};
const sepoliaUrl = (SEPOLIA_URL || SEPOLIA_RPC_URL || "").trim();
if (sepoliaUrl.length > 0) {
  networks.sepolia = {
    url: sepoliaUrl,
    accounts: PRIVATE_KEY ? [PRIVATE_KEY] : [],
  };
}

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.28",
  networks,
  etherscan: {
    apiKey: {
      sepolia: ETHERSCAN_API_KEY || "",
    },
  },
};
