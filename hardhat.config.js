require("@nomiclabs/hardhat-waffle");

// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: {
    compilers: [
      {
          version: "0.4.18",
      },
      {
          version: "0.5.16",
          settings: {},
      },
    ],

  },
  networks: {
    hardhat: {
      forking: {
        url: "https://eth-mainnet.alchemyapi.io/v2/-uiRKA_7y7wlRBBSs30IlXVWDYdpV6hH",
        blockNumber: 14684810
      }
    }
  }
};
