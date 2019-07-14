pragma solidity >0.4.23 <0.6.0;

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

contract BillOfSale {
	address public seller;
	address public buyer;
	string public descr;
	uint256 public price;
	
	event Confirmed(address indexed buyer, address indexed this);
	event Cancelled(address indexed this, address indexed buyer);
	event Received(address indexed this, address indexed seller);
	event WithdrewTokens(address indexed _tokenContract, address indexed seller, uint256 tokenBalance);
	
	constructor(
	    string memory _descr, 
	    uint256 _price,
    	address _seller, 
    	address _buyer) 
    	    public {
    	            descr = _descr;
            	    price = _price;
            	    seller = _seller;
            	    buyer = _buyer;
	                 }
                     /**
                      * @dev Throws if called by any account other than the buyer.
                      */
                        modifier onlyBuyer() {
                        require(msg.sender == buyer);
                         _;
                           }
	                        function confirmPurchase() public payable onlyBuyer {
    	                      require(price == msg.value);
    	                      emit Confirmed(buyer, address(this));
	                        }
	                        function cancel() public onlyBuyer {
    	                      buyer.transfer(address(this).balance);
    	                      emit Cancelled(address(this), buyer);
                            }
	                        function confirmReceipt() public onlyBuyer {
	                          seller.transfer(address(this).balance);
	                          emit Received(address(this), seller);
	                        }
	                        function transferTokens(address _tokenContract) public onlyBuyer {
                              ERC20 token = ERC20(_tokenContract);
                              uint256 tokenBalance = token.balanceOf(this);
                              token.transfer(seller, tokenBalance);
                              emit WithdrewTokens(_tokenContract, seller, tokenBalance);
    }
}
