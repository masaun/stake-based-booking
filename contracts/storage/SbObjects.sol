pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


contract SbObjects {

    struct Customer {
        uint customerId;
        address customerAddress;
        uint amount;
        uint bookedDate;
        bool isComingShop;
        uint comingTime;       
    }
    
    struct LocalOrganization {
        address localOrganizationAddress;
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
