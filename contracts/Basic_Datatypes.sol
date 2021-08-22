//Checking out some data types.
pragma solidity ^0.6.0;

contract Mycontract {
    
    int public myInt = 1;
    uint public myUint = 1;
    //uint256, uint8, ...
    
    bool myBool = true; //not public, hence won't be visible.
    string public myString = "HeLlO, WORld !";
    bytes32 public myBytes32 = "Hello World!";
    address public myAddress = 0x0A098Eda01Ce92ff4A4CCb7A4fFFb5A43EBC70DC;
    
    struct myStruct {
        uint myInt;
        string myString;
    }
    
    myStruct public someStruct = myStruct(1, "in the struct");
    
    function getValue() public pure returns(uint){
        uint value = 1;
        return value;
    }
}