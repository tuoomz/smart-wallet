// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Token is ERC20 {
  //add minter variable
  address public minter;

  //add minter changed event
   event MinterChangedEvent(address minter);

  constructor() public payable ERC20("DBC Token", "DBCToken") {
    minter = msg.sender;
  }

  //Add pass minter role function
  function passMinter(address newMinter) public {
    minter = newMinter;
    emit MinterChangedEvent(newMinter);
  }

  function mint(address account, uint256 amount) public {
     require(msg.sender == minter, "Sender doest have minter privileges");
		_mint(account, amount);
	}
}