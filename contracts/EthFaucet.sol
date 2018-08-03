pragma solidity ^0.4.16;

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

    event WithdrawSuccessful(address indexed emptiedBy);
    event FallbackFunctionFired();
    event BalanceChecked();
    event TransferEther(address indexed requestedBy);

    // Fallback function fires when eth is sent to contract w/o calling a
    // function, or when called function does not exist in contract, or when
    // invalid arguments are passed to a function
    function () payable public {
        emit FallbackFunctionFired();
    }

    // Returns the contract's balance: address(this).balance
    function getContractBalance() public returns (uint contractBalance) {
        emit BalanceChecked();
        return address(this).balance;
    }

    // Contract owner can empty balance + transfer all assets to himselfd
    function withdraw(uint amountToWithdraw) onlyOwner public {
        require(address(this).balance > 0);
        msg.sender.transfer(amountToWithdraw);
        emit WithdrawSuccessful(msg.sender);
    }

    // getEth() transfers 1 eth from contract to msg.sender
    function transferEth(address transferTo) onlyOwner public {
        require(address(this).balance > 1000000000000000000);
        transferTo.transfer(1000000000000000000);
        emit TransferEther(msg.sender);
    }
}