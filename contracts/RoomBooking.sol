//This implements a smart contract which allots 1 room in exchange for a specific amount of ether(>=2). 
//Before allotting, we check whether the room is vacant or not.
//When the room is occupied, the event Occupy(..) is emitted.

pragma solidity ^0.6.0;

contract HotelRoom{
    
    
    enum Statuses { Vacant, Occupied }
    Statuses currentStatus;
    
    event Occupy(address _occupant, uint _value);
    
    address payable public owner;
    
    constructor() public{
        owner = msg.sender;
        currentStatus = Statuses.Vacant;
    }
    
    modifier onlyWhileVacant{
        require(currentStatus == Statuses.Vacant, "Currently Occupied. ");
        _;
    }
    
    modifier costs (uint256 _amount){
         require(msg.value >= _amount , "Not enough ether provided !");
        _;
    }
    
    function recieve() external payable onlyWhileVacant costs(2 ether) {
        currentStatus = Statuses.Occupied;
        owner.transfer(msg.value);
        emit Occupy(msg.sender,msg.value);
    }
}