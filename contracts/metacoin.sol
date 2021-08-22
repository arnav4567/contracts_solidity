// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

// This is just a simple example of a coin-like contract.
// It is not standards compatible and cannot be expected to talk to other
// coin/token contracts. If you want to create a standards-compliant
// token, see: https://github.com/ConsenSys/Tokens. Cheers!

contract MetaCoin {
	mapping (address => uint256) balances;

	event Transfer(address indexed _from, address indexed _to, uint256 _value);

	constructor() public {
		balances[tx.origin] = 100000;
	}

	function sendCoin(address receiver, uint256 amount, address sender) public returns(bool sufficient) {
		if (balances[sender] < amount) return false;
		balances[sender] -= amount;
		balances[receiver] += amount;
		emit Transfer(sender, receiver, amount);
		return true;
	}


	function getBalance(address addr) public view returns(uint256) {
		return balances[addr];
	}
}

contract Loan is MetaCoin {
    mapping (address => uint256) private loans;
     
    event Request(address indexed _from, uint256 P, uint R, uint T, uint256 amt);
    
    address private Owner;

    
    modifier isOwner() {
        require(msg.sender == Owner,"The caller must be the owner !");
        _;
    }
    
    constructor() public {
        // Make the creator of the contract the Owner.
        Owner = msg.sender;
    }
    
    
    
    function add(uint256 a,uint256 b) private pure returns(uint256){
        return a+b;
    }
    
    function mul_and_div(uint256 x, uint256 y, uint256 z) private pure returns(uint256){
        return (x*y)/z;
    }
    
    function getCompoundInterest(uint256 principal, uint rate, uint time) public pure returns(uint256) {
    	// Anyone should be able to use this function to calculate the amount of Compound interest for given P, R, T
        // Solidity does not have a good support for fixed point numbers so we input the rate as a uint
        
        // while(time>0) {
        //     if (time % 2 == 1) {
        //         principal += principal*rate;
        //         time-=1;
        //     } 
        //     else {
        //         rate = 2 * rate + rate * rate;
        //         time/=2;
        //     }
        // }
        
        
        uint256 newrate = rate;
        uint256 newtime = time;
        for(uint256 i=0;i<newtime;i++)
            principal = add(principal, mul_and_div(newrate, principal, 10^18));
            
        return principal;
    }
    
    function reqLoan(uint256 principal, uint rate, uint time) public returns(bool) {
        // A creditor uses this function to request the Owner to settle his loan, and the amount to settle is calculated using the inputs.
        // Also emit the Request event after succesfully adding to the mapping, and return true. Return false if adding to the mapping failed (maybe the user entered a float rate, there were overflows and toPay comes to be lesser than principle, etc.
        uint256 toPay = getCompoundInterest(principal, rate, time);
        if(msg.sender == Owner)
            return false;
        loans[Owner]+=toPay;
        emit Request(msg.sender, principal,rate, time, toPay);
        return true;
        
    }
    
    function getOwnerBalance() public view returns(uint256) {
		// use the getBalance function of MetaCoin contract to view the Balance of the contract Owner.
		uint bal = MetaCoin.getBalance(Owner);
		return bal;
	}
    
    //viewDues and settleDues allow *ONLY* the owner to *view* and *settle* his loans respectively. They take in the address of a creditor as arguments. 
    //viewDues returns a uint256 corresponding to the due amount, and does not modify any state variables. 
    //settleDues returns a bool, true if the dues were settled and false otherwise.
    //use sendCoin function of MetaCoin contract to send the coins required for settling the dues.
    function viewDues(address a) public view isOwner returns(uint){
        uint256 left = loans[a];
        return left;
    }
    
    function settleDues(address a) public payable isOwner returns(bool){
        if(getOwnerBalance()>loans[a]){
            bool res = MetaCoin.sendCoin(a,loans[a],Owner);
            loans[a] = 0;
            return true;
        }
        else{
            bool res = MetaCoin.sendCoin(a,getOwnerBalance(),Owner);
            loans[a]-=getOwnerBalance();
            return false;
        }
    }
}
