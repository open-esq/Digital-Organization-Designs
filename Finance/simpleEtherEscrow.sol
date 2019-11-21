pragma solidity ^0.5.0;

contract simpleEtherEscrow {
    
    address public buyer;
    address payable public seller;
    uint256 public price;
    
    constructor(address payable _seller) payable public {
        buyer = msg.sender;
        seller = _seller;
        price = msg.value;
    }
    
    function release() public {
        require(msg.sender == buyer);
        address(seller).transfer(price);
    }
    
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
