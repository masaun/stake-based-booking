pragma solidity ^0.5.16;
pragma experimental ABIEncoderV2;


import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/ownership/Ownable.sol";

// Storage
import "./storage/SbStorage.sol";
import "./storage/SbConstants.sol";

// DAI
import "./DAI/dai.sol";

// DateTime
import "./lib/BokkyPooBahsDateTimeLibrary/contracts/BokkyPooBahsDateTimeContract.sol";



/***
 * @notice - This contract is that ...
 **/
contract StakeBasedBooking is Ownable, SbStorage, SbConstants {
    using SafeMath for uint;

    uint currentCustomerId = 1;

    address daiAddress;

    Dai public dai;  //@dev - dai.sol
    IERC20 public erc20;
    BokkyPooBahsDateTimeContract public bokkyPooBahsDateTimeContract;

    constructor(address _erc20, address _bokkyPooBahsDateTimeContract) public {
        dai = Dai(_erc20);
        erc20 = IERC20(_erc20);
        bokkyPooBahsDateTimeContract = BokkyPooBahsDateTimeContract(_bokkyPooBahsDateTimeContract);

        daiAddress = _erc20;
    }

    /***
     * @dev - Character
     * Customer
     * Shop
     * DonatedOrganization
     **/

    /***
     * @dev - Register Local Shop here
     **/
    function registerLocalShop(string memory _localShopName, address _localShopAddress) public returns (bool) {
        LocalShop memory localShop = LocalShop({
            localShopName: _localShopName,
            localShopAddress: _localShopAddress
        });
        localShops.push(localShop);

        emit RegisterLocalShop(localShop.localShopName,
                               localShop.localShopAddress);
    }
     
    /***
     * @dev - Register Local Organization (Local NGO/NPO, etc...) to donationList
     **/
    function registerLocalOrganization(string memory _localOrganizationName, address _localOrganizationAddress) public returns (bool) {
        LocalOrganization memory localOrganization = LocalOrganization({
            localOrganizationName: _localOrganizationName,
            localOrganizationAddress: _localOrganizationAddress
        });
        localOrganizations.push(localOrganization);

        emit RegisterLocalOrganization(localOrganization.localOrganizationName,
                                       localOrganization.localOrganizationAddress);
    }

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

        //@dev - Transfer to shop's wallet address
        address _shopAddress = 0x8Fc9d07b1B9542A71C4ba1702Cd230E160af6EB3;  // For testing
        dai.transfer(_shopAddress, _amount);

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
     * @dev - Distribute pooled money
     *      - The period for tally and executing distribution is 24:00 every day
     **/
    function distributePooledMoney() public returns (bool) {
        //@dev - Get tatal balance which booked date is today
        uint _totalBookedBalanceToday = getTotalBookedBalanceToday();

        //@dev - Calculate distributed amount per 1 address
        uint _numberOfDistributedAddress = getNumberOfDistributedAddress();
        uint distributedAmountPerOneAddress = _totalBookedBalanceToday.div(_numberOfDistributedAddress);

        //@dev - Execute distribution
        for (uint i=1; i <= currentCustomerId; i++) {
            if (getDistributedAddress(i) != address(0)) {
                address to = getDistributedAddress(i);
                erc20.transfer(to, distributedAmountPerOneAddress);
            }
        }

        emit DistributePooledMoney(_totalBookedBalanceToday, _numberOfDistributedAddress, distributedAmountPerOneAddress);
    }


    /************************************
     * @dev - Internal functions
     ************************************/
    function getTimeframeToday() public view returns (uint _startTime, uint _endTime, uint _today) {
        uint timestampNow = now;
        uint year;
        uint month;
        uint day;
        (year, month, day) = bokkyPooBahsDateTimeContract.timestampToDate(timestampNow); //@return - i.e). 2020/04/25 
        uint today = bokkyPooBahsDateTimeContract.timestampFromDate(year, month, day);   //@return - i.e). 1587772800 (=2020/04/25 0:00am) 
        //uint today = bokkyPooBahsDateTimeContract.getDay(timestamp);                   //@return - i.e). 25

        uint startTime = today;
        uint endTime = today + 1 days;

        return (startTime, endTime, today);
    }

    function getDistributedAddress(uint _customerId) internal view returns (address distributedAddress) {
        //@dev - Time frame of today
        uint startTime;
        uint endTime;
        uint today;
        (startTime, endTime, today) = getTimeframeToday();

        address distributedAddress;

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

        return distributedAddress;
    }

    function getNumberOfDistributedAddress() internal view returns (uint _numberOfDistributedAddress) {
        //@dev - Time frame of today
        uint startTime;
        uint endTime;
        uint today;
        (startTime, endTime, today) = getTimeframeToday();

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
        uint today;
        (startTime, endTime, today) = getTimeframeToday();

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
        uint256 _exchangeRateCurrent = SbConstants.onePercent;

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

        return (SbConstants.CONFIRMED, _approvedValue);
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
    }
    
}
