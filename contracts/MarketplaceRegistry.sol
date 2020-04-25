pragma solidity ^0.5.10;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

// Storage
import "./storage/McStorage.sol";
import "./storage/McConstants.sol";

// DAI
import "./DAI/dai.sol";

// Mexa
// import "./mexa/contracts/RelayHub.sol";
// import "./mexa/contracts/RelayerManager.sol";



/***
 * @notice - This contract is that ...
 **/
contract MarketplaceRegistry is Ownable, McStorage, McConstants {
    using SafeMath for uint;

    address daiAddress;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;

    constructor(address _erc20) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);

        daiAddress = _erc20;
    }

    /***
     * @dev - Character
     * Customer
     * Shop
     * DonatedOrganization
     **/


    /***
     * @dev - Stake DAI when customr book
     **/
    function booking(address _customer, uint256 _amount) public returns (bool) {}
    
    /***
     * @dev - Check whether booked customer come or not
     **/
    function approveCustomerComeShop() public returns (bool) {}
    
    /***
     * @dev - Local Organization register to donationList
     **/
    function registerLocalOrganization() public returns (bool) {}

    /***
     * @dev - Destribute pooled money
     *      - The period for tally and executing distribution is 24:00 every day
     **/
    function destributePooledMoney() public returns (bool) {}









    /***
     * @dev - Test Functions
     **/
    function testFunc(uint256 _mintAmount) public returns (bool, uint256 _approvedValue) {
        uint256 _id = 1;
        uint256 _exchangeRateCurrent = McConstants.onePercent;

        address _to = 0x8Fc9d07b1B9542A71C4ba1702Cd230E160af6EB3;

        //address _owner = address(this); //@dev - contract address which do delegate call
        address _owner = msg.sender;
        address _spender = 0xaD6D458402F60fD3Bd25163575031ACDce07538D;    // DAI address on Ropsten
        //address _spender = 0x4F96Fe3b7A6Cf9725f59d353F723c1bDb64CA6Aa;    // DAI address on Kovan

        //@dev - Allow _spender to withdraw from your account, multiple times, up to the _value amount. 
        erc20.approve(_spender, _mintAmount);
            
        //@dev - Returns the amount which _spender is still allowed to withdraw from _owner
        uint256 _approvedValue = erc20.allowance(_owner, _spender);
        
        //@dev - Expected transferred value is 1.05 DAI（= 1050000000000000000 Wei）
        erc20.transfer(_to, _mintAmount);        

        emit Example(_id, _exchangeRateCurrent, msg.sender, _approvedValue);

        return (McConstants.CONFIRMED, _approvedValue);
    }

    function balanceOfCurrentAccount(address _currentAccount) public view returns (uint256 balanceOfCurrentAccount) {
        return erc20.balanceOf(_currentAccount);
    }
    

    function transferDAIFromUserToContract(uint256 _mintAmount) public returns (bool) {
        address _from = address(this);
        address _to = 0x8Fc9d07b1B9542A71C4ba1702Cd230E160af6EB3;

        erc20.approve(daiAddress, _mintAmount);
        uint256 _allowanceAmount = erc20.allowance(address(this), daiAddress);

        erc20.transferFrom(_from, _to, _mintAmount);

        emit _TransferFrom(_from, _to, _mintAmount, _allowanceAmount);

        // erc20.approve(daiAddress, _mintAmount.mul(10**18));
        // uint256 _allowanceAmount = erc20.allowance(address(this), daiAddress);

        // erc20.transferFrom(_from, _to, _mintAmount.mul(10**18).div(10**2));

        // emit _TransferFrom(_from, _to, _mintAmount.mul(10**18), _allowanceAmount);
    }
    
}
