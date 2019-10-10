pragma solidity 0.4.26;

contract Bakery {

  // index of created contracts

  mapping (address => bool) public validContracts; 
  address[] public contracts;

  // useful to know the row count in contracts index

  function getContractCount() 
    public
    view
    returns(uint contractCount)
  {
    return contracts.length;
  }

  // get all contracts

  function getDeployedContracts() public view returns (address[])
  {
    return contracts;
  }

  // deploy a new contract

  function newCookie(string flavor)
    public
    returns(address)
  {
    Cookie c = new Cookie(msg.sender, flavor);
    validContracts[c] = true;
    contracts.push(c);
    return c;
  }

  // access child functions

  function getFlavor(address cookie)
    public
    view
    returns(string)
  {
    //ensure valid address
    require(validContracts[cookie],"Contract Not Found!");

    return (Cookie(cookie).getFlavor());
  }


}

contract Cookie {
  
  address public owner;
  address public factory;
  string public flavor;

  // standard constructor

  constructor (address _owner, string _flavor) public {
    owner = _owner;
    factory = msg.sender;
    flavor = _flavor;
  }

  // suppose the deployed contract has a purpose

  function getFlavor()
    public
    view
    returns (string)
  {
    return flavor;
  }    
}
