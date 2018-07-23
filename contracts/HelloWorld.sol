pragma solidity ^0.4.0;

contract HelloWorld {
  address public creator;
  uint public myNumber;
  string public message;

  constructor() public {
    creator = msg.sender;
    message = "Hello world";
    myNumber = 5;
  }
}