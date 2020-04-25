pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


contract McObjects {

    struct Customer {
        uint customerId
        address address;
        uint amount;
        bool isComingShop;        
    }
    


    enum ExampleType { TypeA, TypeB, TypeC }

    struct ExampleObject {
        address addr;
        uint amount;
    }

    struct Sample {
        address addr;
        uint amount;
    }

}
