//This file takes a string from the user and stores it. 
//Now, we ensure that only the owner can view that string, so this logic can be used to store personal information of the users.
pragma solidity ^0.6.0;

contract ownable{//to ensure that some operations can only be done by the owner.
    address owner;
    
    constructor() public{
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner,"must be owner");
        _;
    }
}

contract SecretVault{//this contains the secret message given by the owner of the contract.
    string secret;
    
    constructor(string memory _secret) public{
        secret = _secret;
    }
    
    function getSecret() public view returns(string memory){
        return secret;
    }
}


contract MyContract is ownable{     //inheritance
    address public secretVault;     //public, so anyone can see which user has the said secret data.
    
    constructor(string memory _secret) public{//constructor takes the required string as input!
        SecretVault _secretVault = new SecretVault(_secret);
        secretVault = address(_secretVault);
        //super;
    }
    
    function getSecret() public view onlyOwner returns(string memory){
        SecretVault _secretVault = SecretVault(secretVault);
        return _secretVault.getSecret();
    }
}