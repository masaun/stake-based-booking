pragma solidity ^0.5.11;
pragma experimental ABIEncoderV2;


contract SbObjects {

    struct Customer {
        uint customerId;
        address customerAddress;
        uint bookedShopId;
        uint bookedDate;
        uint amount;
        bool isComingShop;
        uint comingTime;       
    }
    
    struct LocalShop {
        uint localShopId;
        string localShopName;
        address localShopAddress;
    }    

    struct LocalOrganization {
        string localOrganizationName;
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
