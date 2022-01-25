pragma solidity ^0.6.0;

/**
  This is a simple - and naive - smart contract for betting...
  You can bet your tokens to improve your extra credit....at your own risk!
  
  This contract have 2 security issues, one can make you lose tokens and the
  other allows the attacker to drain all tokens from the contract! 
  
  HINT: just don't accept a loss! 
  
*/

import "./BonusToken.sol";

contract NaiveBet {

  address owner;
  BonusToken bt;

  constructor(BonusToken _bt) public {
    owner = msg.sender;
    bt = _bt;
  }

  function bet() public {
    require (bt.allowance(msg.sender,address(this))>0,"Show me the token!");
    uint256 betValue = bt.allowance(msg.sender,address(this));
    bt.transferFrom(msg.sender,address(this),betValue);
    if ( uint256(blockhash(block.number-1)) % 2 ==0) {
      bt.transfer(msg.sender,2*betValue);
    } 

  }

}
