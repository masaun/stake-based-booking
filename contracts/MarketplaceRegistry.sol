pragma solidity ^0.5.15;
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

    uint currentCustomerId = 1;

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
    function booking(uint _amount, uint _bookedDate) public returns (bool) {
        Customer storage customer = customers[currentCustomerId];
        customer.customerId = currentCustomerId;
        customer.customerAddress = msg.sender;
        customer.bookedDate = _bookedDate;
        customer.amount = _amount;
        customer.isComingShop = false;

        emit Booking(customer.customerId, 
                     customer.customerAddress, 
                     customer.amount, 
                     customer.bookedDate,
                     customer.isComingShop);

        currentCustomerId++;
    }
    
    /***
     * @dev - Check whether booked customer come or not
     **/
    function approveCustomerComeShop(uint _customerId) public returns (bool) {
        Customer storage customer = customers[_customerId];
        customer.isComingShop = true;
        customer.comingTime = now;

        emit ApproveCustomerComeShop(_customerId, 
                                     customer.isComingShop, 
                                     customer.comingTime);
    }
    
    /***
     * @dev - Local Organization register to donationList
     **/
    function registerLocalOrganization() public returns (bool) {}

    /***
     * @dev - Distribute pooled money
     *      - The period for tally and executing distribution is 24:00 every day
     **/
    function distributePooledMoney() public returns (bool) {
        //@dev - Time frame of today
        uint startTime;
        uint endTime;
        (startTime, endTime) = getTimeframeToday();

        //@dev - Actual time when booked customer came
        //address[] memory _distributedAddressList = getDistributedAddress();

        //@dev - Get tatal balance which booked date is today
        uint _totalBookedBalanceToday = getTotalBookedBalanceToday();

        //@dev - Calculate distributed amount per 1 address
        uint _numberOfDistributedAddress = getNumberOfDistributedAddress();
        uint distributedAmountPerOneAddress = _totalBookedBalanceToday.div(_numberOfDistributedAddress);

        //@dev - Execute distribution 
        // uint i = 1;
        // while (i <= currentCustomerId) {
        //     //address _distributedAddress = getDistributedAddress(i);
        //     if (getDistributedAddress(i) != address(0)) {
        //
        //     }
        // } 

        for (uint i=1; i <= currentCustomerId; i++) {
            //address _distributedAddress = getDistributedAddress(i);
            if (getDistributedAddress(i) != address(0)) {
                address to = getDistributedAddress(i);
                erc20.transfer(to, distributedAmountPerOneAddress);
            }
        }
    }

    function getTimeframeToday() internal view returns (uint _startTime, uint _endTime) {
        uint startTime = now;
        uint endTime = now + 1 days;

        return (_startTime, _endTime);
    }

    function getDistributedAddress(uint _customerId) internal view returns (address distributedAddress) {
        //@dev - Time frame of today
        uint startTime;
        uint endTime;
        (startTime, endTime) = getTimeframeToday();

        address distributedAddress;
        //address[] memory distributedAddressList;

        //@dev - Actual time when booked customer came
        Customer memory customer = customers[_customerId];
        address _customerAddress = customer.customerAddress;
        bool _isComingShop = customer.isComingShop;
        uint _comingTime = customer.comingTime;

        if (_isComingShop == true) {
            if (startTime <= _comingTime && _comingTime <= endTime) {
                distributedAddress = _customerAddress;
            }
        }

        //@dev - Actual time when booked customer came
        // for (uint i=1; i <= currentCustomerId; i++) {
        //     Customer memory customer = customers[i];
        //     address _customerAddress = customer.customerAddress;
        //     bool _isComingShop = customer.isComingShop;
        //     uint _comingTime = customer.comingTime;

        //     if (_isComingShop == true) {
        //         if (startTime <= _comingTime && _comingTime <= endTime) {
        //             distributedAddressList.push(_customerAddress);
        //         }
        //     }
        // }

        return distributedAddress;
        //return distributedAddressList;
    }
    

    function getNumberOfDistributedAddress() internal view returns (uint _numberOfDistributedAddress) {
        uint numberOfDistributedAddress = 0;

        for (uint i=1; i <= currentCustomerId; i++) {
            Customer memory customer = customers[i];
            address _customerAddress = customer.customerAddress;
            bool _isComingShop = customer.isComingShop;
            uint _comingTime = customer.comingTime;

            if (_isComingShop == true) {
                if (startTime <= _comingTime && _comingTime <= endTime) {
                    numberOfDistributedAddress++;
                }
            }
        }
    }
    

    function getTotalBookedBalanceToday() internal view returns (uint _totalBookedBalanceToday) {
        //@dev - Time frame of today
        uint startTime;
        uint endTime;
        (startTime, endTime) = getTimeframeToday();

        uint totalBookedBalanceToday;

        for (uint i=1; i <= currentCustomerId; i++) {
            Customer memory customer = customers[i];
            address _customerAddress = customer.customerAddress;
            bool _isComingShop = customer.isComingShop;
            uint _comingTime = customer.comingTime;
            uint _amount = customer.amount;

            if (_isComingShop == true) {
                if (startTime <= _comingTime && _comingTime <= endTime) {
                    totalBookedBalanceToday.add(_amount);
                }
            }
        }

        return totalBookedBalanceToday;
    }









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
