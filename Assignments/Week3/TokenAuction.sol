// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.25 <0.6.0;

/**
 * @title TokenAuction
 * @dev This contract handles the auction of a VerySimpleToken.
 * In short, a token owner can create one auction, providing the name of this auction,
 * how long this auctio will last (in number of blocks) and the token.
 * Before  calling initAuction the token owner should transfer the token to the contract.
 * Any one can bid in this auction, but before bidding, a bidder must send a collateral to contract.
 * When the auction ends, the bidder can collect the collater,, but the winner have to pay for the token.
 *
 * Exercices:
 * 1 - The fee collected by contract owner is defined  at deploy time. Change the contract alowing to contract owner Change
 *     the fee value without compromising the "trusteless" of the contract.
 *
 * 2 - The collateral is usefull to enforce a honest behaviour from the bidders. But if the winner does not pay the bid, the token owner is also punished:
 *     the token is locked in the contract!
 *     Change this behavior giving some time for the payment and, if it doesn't,
 *     the token goes back to tokenOwner, who will also receive the collateral as compensation
 *
 * 3 - (Bug Bounty - Extra Credit)  There are 3 bugs in the contract. See if you can find and fix them
 *
 * 4 - Finally, the token owner can still lose the token without receiving anything...how? 
 */

import "./VerySimpleToken.sol";

contract TokenAuction {
  enum AuctionStates { Prep, Bid, Finished}


  address payable owner;

  struct OneAuction {
  	 AuctionStates myState;
     mapping (address => bool) collateral;
  	 uint blocklimit;
  	 address winner;
  	 address payable tokenOwner;
  	 uint winnerBid;
  	 bool payment;
	   VerySimpleToken token;
  }

  uint collateralValue;
  uint contractFee;

  mapping (string => OneAuction) myAuctions;


  constructor(uint c,uint fee) public {
    owner = msg.sender;
    collateralValue = c;
    contractFee = fee;
  }

  function createAuction(string memory name, uint time, VerySimpleToken t) public {
    require (t.isOwner(msg.sender),"You must own the token to create one auction!");
    OneAuction memory l;
    l.blocklimit= block.number + time;
    l.myState = AuctionStates.Prep;
    l.winnerBid = 0;
    l.tokenOwner = msg.sender;
    l.payment = false;
    l.token = t;
    //Bug1
    myAuctions[name]=l;
  }

  function initAuction(string memory name) public {
  	 require (myAuctions[name].myState == AuctionStates.Prep, "The auction should be in Prep state");
	   require (myAuctions[name].token.isOwner(address(this)),"The contract should own the token");
     myAuctions[name].myState = AuctionStates.Bid;

  }

  function sendCollateral(string memory name) public payable {
    require (myAuctions[name].myState == AuctionStates.Bid, "The auction should be in Bid state");
    require (msg.value == collateralValue,"You should send the corretc value!");
    myAuctions[name].collateral[msg.sender] = true;
  }

  function bid(string memory name, uint v) public {
    OneAuction storage a = myAuctions[name];
    verifyFinished(a);
    require (a.myState == AuctionStates.Bid, "The auction should be in Bid state");
    require (a.collateral[msg.sender],"Send the collateral value before bidding.");
    if (v>a.winnerBid) {
      a.winnerBid = v;
      a.winner = msg.sender;
    }
  }

  function verifyFinished(OneAuction storage a) private {
    if (block.number > a.blocklimit) {
        a.myState = AuctionStates.Finished;
      }
    }

    function claimToken(string memory name) public payable {
      //Bug2
      OneAuction storage a = myAuctions[name];
      verifyFinished(a);
      require (a.myState == AuctionStates.Finished, "Wait a minute, boys, this one is not dead");
      require (msg.value == a.winnerBid-collateralValue, "Pay First....");
      a.token.transfer(msg.sender);
      a.collateral[a.winner] = false; //just to flag claimToken
    }

    function claimCollateral(string memory name) public {
      OneAuction storage a = myAuctions[name];
      verifyFinished(a);
      require (a.myState == AuctionStates.Finished, "Wait a minute, boys, this one is not dead");
      require (a.collateral[msg.sender],"Nope");
      require (msg.sender != a.winner,"You cant claim the collateral");
      msg.sender.transfer(collateralValue);
      myAuctions[name].collateral[msg.sender] =false;

    }

    function getProfit(string memory name) public {
      OneAuction storage a = myAuctions[name];
      verifyFinished(a);
      require (a.payment==false, "I will not pay twice!");
      require (a.collateral[a.winner] ==false,"Wait for payment");
      a.tokenOwner.transfer(a.winnerBid-contractFee);
      a.payment=true;
    }

    function getFee() public {
      //Once everyone has been paid, let's take the full balance as fee.
      //Bug3
      owner.transfer(address(this).balance);
    }

}
