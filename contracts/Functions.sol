//A function to count the no. of even integers in an array(countEven()), and another to check for the owner(isOwner())
pragma solidity ^0.6.0;

contract MyContract{
    uint[] public nums = [1,2,3,4,5,6,7,8,9,10];
    address public owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    function countEven() public view returns(uint){
        uint count = 0;
        
        for(uint i=0; i<nums.length;i++){
            if(isEven(nums[i])==true)
                count++;
        }
        return count;
    }
    
    function isEven(uint _num) public view returns(bool){
        if(_num%2==0)
            return true;
        else
            return false;
    }
    
    function isOwner() public view returns(bool){
        return(msg.sender==owner);
    }
}