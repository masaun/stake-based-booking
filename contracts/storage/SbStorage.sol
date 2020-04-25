pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;

import "./SbObjects.sol";
import "./SbEvents.sol";


// shared storage
contract SbStorage is SbObjects, SbEvents {

    ///////////////////////////////////
    // @dev - Define as memory
    ///////////////////////////////////
    address[] exampleGroups;

    
    //////////////////////////////////
    // @dev - Define as storage
    ///////////////////////////////////
    mapping (uint => Customer) customers;
    

    ExampleObject[] public exampleObjects;

    mapping (uint256 => Sample) samples;

}
