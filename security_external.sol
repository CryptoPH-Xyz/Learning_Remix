pragma solidity 0.8.2;

contract unsafeBank { //Unsafe - allows Re Entrancy
// Consider the ORDER that it is executed
    
    mapping(address => uint) balance;
    
    //The exploiter (with fallback function) will call this function from another contract
    function withdraw() public {
        require(balance[msg.sender] > 0); //CHECKS
        payable(msg.sender).transfer(balance[msg.sender]); // INTERACTIONS
    //fallback function will reach here (again and again) before msg.sender's balance is set to 0
        balance[msg.sender] = 0; //EFFECTS
    }
    
    // deposit function
    // another contract (with a fallback function) will exploit this contract 
}

// We fix this by following a pattern in solidity
// CHECKS, EFFECTS, INTERACTIONS - pattern 

contract solvesReEntrancy {
    
    mapping (address => uint) balance;
    
    function withdraw() public {
        require(balance[msg.sender] > 0); // Checks
        uint toTransfer = balance[msg.sender]; // We do this so we have a temporary vairable to transfer the money
        balance[msg.sender] = 0; // Effects
// change send to call      
        //bool success = msg.sender.send(toTransfer); // Interactions
        (bool success,) = msg.sender.call{value: toTransfer}(""); // Interactions using call
        if (!success){
            balance[msg.sender] = toTransfer; // resets the balance if transfer is not successful
        }
    }
}

// send and transfer (introduced after the DAO hackk) has 2,300 gas stipend each
// msg.sender.call.value(amount)("") - call has unlimited gas stipend (used before send and transfer was introduced)


contract attack {
// trial external contract to attack unsafeBank 
    function start() public {
        //deposit funds to bank
        //call to withdraw();
    }   
//receive function    
    //used for calls with no data with value
    receive() external payable{
        //new call to withdraw
    }
    
    //when no other function matches
    fallback() external payable {
        
    }
}










