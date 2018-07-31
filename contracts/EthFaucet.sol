//  We want our faucet to:
//    - Store eth on the contract
//    - Send 1 eth to tx sender
//    - Accept donations (refills) from anyone
//    - Allow the owner to withdraw all eth from contract

pragma solidity ^0.4.16;

//  @title Ownership contract
//  @dev enables ownership of the faucet contract

contract owned {
    address public owner;

    constructor() public {
        owner = msg.sender;
    }

    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }

    function transferOwnership(address newOwner) onlyOwner public {
        owner = newOwner;
    }
    
}

contract IsPayable is owned {
    uint public balance;
    string public lastEmittedText;

    event Tapped(address tappedBy);
    event emitText(string textToEmit);
    
    // On deployment, contract's balance is 0
    constructor() public {
        balance = 0;
    }

    // A fallback function that fires when eth is sent w/o a call
    function () payable public {
        balance = balance + msg.value;
    }

    function testEmit(string text) public {
        lastEmittedText = text;
        emit emitText(text);
    }

    function getText() public view returns (string textToReturn) {
        return lastEmittedText;
    }

    function getEth() public {
        msg.sender.transfer(1000000000000000000);
        emit Tapped(msg.sender);
    }

}