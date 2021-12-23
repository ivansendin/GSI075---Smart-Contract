pragma solidity >=0.4.25 <0.6.0;

/*

This is a VerySimpleToken....if you want to use our learn about tokens see ERC20 and ERC721 documentation!

*/

contract VerySimpleToken {
	 string name;
	 address tokenOwner;
	 constructor(string memory  _n) public {
	 	tokenOwner = msg.sender;
		name = _n;
	 }

	 function transfer(address to) public {
	 	  require (msg.sender == tokenOwner);
		  tokenOwner = to;
	 }

	 function isOwner(address d) public returns (bool) {
	          return (d == tokenOwner);
	 }

}
