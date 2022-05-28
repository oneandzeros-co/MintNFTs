/**
 * @type import('hardhat/config').HardhatUserConfig
 */

 require("@nomiclabs/hardhat-waffle");
 require("@nomiclabs/hardhat-ethers");
 require("@nomiclabs/hardhat-etherscan");
 require("dotenv").config();
 const { ALCHEMY_KEY, ACCOUNT_PRIVATE_KEY, ETHERSCAN_API_KEY } = process.env;
 
 module.exports = {
   solidity: "0.8.1",
   defaultNetwork: "rinkeby",
   networks: {
     hardhat: {},
     rinkeby: {
       url: `https://eth-rinkeby.alchemyapi.io/v2/${ALCHEMY_KEY}`,
       accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
     },
     mumbai: {
       url: `https://polygon-mumbai.g.alchemy.com/v2/${ALCHEMY_KEY}`,
       accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
     },
     ethereum: {
       chainId: 1,
       url: `https://eth-mainnet.alchemyapi.io/v2/${ALCHEMY_KEY}`,
       accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
     },
     polygon: {
       chainId: 137,
       url: `https://polygon-mainnet.g.alchemy.com/v2/${ALCHEMY_KEY}`,
       accounts: [`0x${ACCOUNT_PRIVATE_KEY}`],
     },
   },
   etherscan: {
     apiKey: ETHERSCAN_API_KEY,
   },
 };