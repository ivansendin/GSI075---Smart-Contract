pragma solidity ^0.6.0;

**
  @title BonusToken
  
  This contract aims to manage the extra credits of this course.
  He is purposefully simple and dangerous...there will be regrets.
  Its issues will be fixed in the next contracts and we will have to deal with the lack of updates in contracts!
  
*/

import "OpenZeppelin/openzeppelin-contracts@3.0.0/contracts/token/ERC20/ERC20.sol";

contract BonusToken is ERC20 {
    constructor(uint256 initialSupply) public ERC20("BonusToken", "BTK") {
        _mint(msg.sender, initialSupply);
}


function getExtraCredit(address student) public view returns (uint256) {
  uint256 b = balanceOf(student);
  if (b<10000) {
    return 0;
  }
  uint256 extra =  (b-10000)/1000;
  if (extra>20) {
    return 20;
  }
  return extra;
 }
}
