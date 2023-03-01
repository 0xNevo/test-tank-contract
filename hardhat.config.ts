require("dotenv").config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");

const MUMBAI_API_KEY = "gisZbr51M0vHXK714NK3G9P2n1PK6zyf";
const MAINNET_API_KEY = "P4zyQcq0jXcpO_8vhujqwV236ngHi4S3";

module.exports = {
  solidity: "0.8.17",

  networks: {
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${MUMBAI_API_KEY}`,
      accounts: [`0x` + process.env.PRIVATE_KEY],
      chainId: 80001,
    },
    mainnet: {
      url: `https://polygon-mainnet.g.alchemy.com/v2/${MAINNET_API_KEY}`,
      accounts: [`0x` + process.env.PRIVATE_KEY],
      chainId: 137,
    },
  },
  etherscan: {
    apiKey: "MT18645RJYR1U122XYG4ZKPHDA9TYJSV5X"
  },
};