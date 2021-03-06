var StakeBasedBooking = artifacts.require("StakeBasedBooking");
var IERC20 = artifacts.require("IERC20");

//@dev - Import from exported file
var tokenAddressList = require('./tokenAddress/tokenAddress.js');
var contractAddressList = require('./contractAddress/contractAddress.js');

//const _erc20 = tokenAddressList["Kovan"]["DAI"];  // DAI address on Kovan
const _erc20 = tokenAddressList["Ropsten"]["DAI"];  // DAI address on Ropsten
const _bokkyPooBahsDateTimeContract = contractAddressList["Ropten"]["BokkyPooBahsDateTimeLibrary"]["BokkyPooBahsDateTimeContract"];

const depositedAmount = web3.utils.toWei("2.1");    // 2.1 DAI which is deposited in deployed contract. 

module.exports = async function(deployer, network, accounts) {
    await deployer.deploy(StakeBasedBooking, 
                          _erc20, 
                          _bokkyPooBahsDateTimeContract);

    const stakeBasedBooking = await StakeBasedBooking.deployed();

    const iERC20 = await IERC20.at(_erc20);

    //@dev - Transfer 2.1 DAI from deployer's address to contract address in advance
    await iERC20.transfer(stakeBasedBooking.address, depositedAmount);
};
