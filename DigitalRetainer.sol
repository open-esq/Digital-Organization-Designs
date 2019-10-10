pragma solidity 0.4.26;

contract DigitalRetainer {

string public Terms = "Establishing a retainer, Client, indentified as ethereum address [[Client Ethereum Address]], commits a digital payment transactional script capped at $[[Payment Cap in Dollars]] for the benefit of Provider, identified as ethereum address [[Provider Ethereum Address]], in exchange for the prompt satisfaction of the following deliverables to Client by Provider upon payments made hereby: [[Deliverable]], set at the rate of $[[Deliverable Rate]] per deliverable.";

// ERC-20 Token References
uint256 private decimalFactor = 10**uint256(18); // adjusts input token payment amounts to wei amount for ux 
address public daiToken = 0x8ad3aA5d5ff084307d28C8f514D7a193B2Bfe725; // designated ERC-20 token for payments
address public usdcToken = 0x8ad3aA5d5ff084307d28C8f514D7a193B2Bfe725; // designated ERC-20 token for payments

// Service Retainer References
address public client = 0xA7eC69d5f6d9bb298aB54A5F228aA6e96B865eB1; // client ethereum address 
address public provider = 0xA7eC69d5f6d9bb298aB54A5F228aA6e96B865eB1; // ethereum address that receives payments in exchange for goods or services
string public deliverable = "Truth"; // goods or services (deliverable) retained for benefit of ethereum payments

uint256 public paid;
uint256 public payCap = 10;

event Paid(uint256 amount, address indexed); // triggered on successful ERC-20 token payments 

function payDAI(uint256 amount) public { // forwards approved DAI token amount to provider ethereum address
require(paid <= payCap, "payDAI: payCap exceeded");
require(paid + amount <= payCap, "payDAI: payCap exceeded");
uint256 weiAmount = amount * decimalFactor;
ERC20 dai = ERC20(daiToken);
dai.transferFrom(msg.sender, provider, weiAmount);
emit Paid(weiAmount, msg.sender);
paid = paid + amount;
}

function payUSDC(uint256 amount) public { // forwards approved USDC token amount to provider ethereum address
require(paid <= payCap, "payUSDC: payCap exceeded");
require(paid + amount <= payCap, "payUSDC: payCap exceeded");
uint256 weiAmount = amount * decimalFactor;
ERC20 usdc = ERC20(usdcToken);
usdc.transferFrom(msg.sender, provider, weiAmount);
emit Paid(weiAmount, msg.sender);
paid = paid + amount;
}
}

/**
 * @title ERC20
 * @dev see https://github.com/ethereum/EIPs/issues/20
 */
contract ERC20 {
  uint256 public totalSupply;

  function balanceOf(address who) public view returns (uint256);
  function transfer(address to, uint256 value) public returns (bool);
  function allowance(address owner, address spender) public view returns (uint256);
  function transferFrom(address from, address to, uint256 value) public returns (bool);
  function approve(address spender, uint256 value) public returns (bool);

  event Approval(address indexed owner, address indexed spender, uint256 value);
  event Transfer(address indexed from, address indexed to, uint256 value);
} 
