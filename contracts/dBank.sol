// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "./Token.sol";

contract dBank {

  //assign Token contract to variable
  Token token;

  //add mappings
  mapping(address => bool) public hasDepositedFunds;
  mapping(address => uint256) public balance;
  mapping(address => uint256) public depositTime;


  //add events
  event Deposit(address _address, uint value);
  event Withdraw(address _address, uint value, uint interest);

  //pass as constructor argument deployed Token contract
  constructor(Token _token) public {
    //assign token deployed contract to variable
    token =_token;
    token.passMinter(address(this));
  }

  function deposit() payable public {
    //check if msg.sender didn't already deposited funds
    require( hasDepositedFunds[msg.sender] == false, "User has allready depsoited funds");
    //check if msg.value is >= than 0.01 ETH (10000000000000000 Gwei)
    require(msg.value >= 10000000000000000, "Sender needs to deposit more than 0.01 eth");

    //increase msg.sender ether deposit balance
    balance[msg.sender] = msg.value;

    //start msg.sender hodling time
    depositTime[msg.sender] = block.timestamp;

    //set msg.sender deposit status to true
    hasDepositedFunds[msg.sender] = true;

    //emit Deposit event
    emit Deposit(msg.sender, msg.value); 

  }

  function withdraw() public {
    //check if msg.sender deposit status is true
    require(hasDepositedFunds[msg.sender] == true, "User has not deposited funds yet");
    //assign msg.sender ether deposit balance to variable for event
    uint256 depositBalance = balance[msg.sender];

    //check user's hodl time
    uint256 timeInSeconds = (block.timestamp) - depositTime[msg.sender];

    //calc interest per second 
    // I chose 1 token every second

    //calc accrued interest
    uint256 interest = timeInSeconds * depositBalance;

    //send eth to user
    msg.sender.transfer(depositBalance);

    //send interest in tokens to user
    token.mint(msg.sender, interest);

    //reset depositer data
    balance[msg.sender] = 0;
    hasDepositedFunds[msg.sender] = false;

    //emit event
    emit Withdraw(msg.sender, depositBalance, interest);

  }

  function borrow() payable public {
    //check if collateral is >= than 0.01 ETH
    //check if user doesn't have active loan

    //add msg.value to ether collateral

    //calc tokens amount to mint, 50% of msg.value

    //mint&send tokens to user

    //activate borrower's loan status

    //emit event
  }

  function payOff() public {
    //check if loan is active
    //transfer tokens from user back to the contract

    //calc fee

    //send user's collateral minus fee

    //reset borrower's data

    //emit event
  }
}