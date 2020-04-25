pragma solidity ^0.5.11;

import "./McObjects.sol";


contract McEvents {

    event Booking(
        uint customerId,
        address address,
        uint amount,
        bool isComingShop 
    );
    

    event _TransferFrom(
        address from,
        address to,
        uint256 transferredAmount,
        uint256 allowanceAmount
    );

    event Example(
        uint256 indexed Id, 
        uint256 exchangeRateCurrent,
        address msgSender,
        uint256 approvedValue    
    );

}
