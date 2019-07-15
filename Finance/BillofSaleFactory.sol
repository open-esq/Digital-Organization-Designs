pragma solidity 0.4.26;

/**
 * @dev Wrappers over Solidity's arithmetic operations with added overflow
 * checks.
 *
 * Arithmetic operations in Solidity wrap on overflow. This can easily result
 * in bugs, because programmers usually assume that an overflow raises an
 * error, which is the standard behavior in high level programming languages.
 * `SafeMath` restores this intuition by reverting the transaction when an
 * operation overflows.
 *
 * Using this library instead of the unchecked operations eliminates an entire
 * class of bugs, so it's recommended to use it always.
 */
library SafeMath {
    /**
     * @dev Returns the addition of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `+` operator.
     *
     * Requirements:
     * - Addition cannot overflow.
     */
    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a, "SafeMath: addition overflow");

        return c;
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     */
    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a, "SafeMath: subtraction overflow");
        uint256 c = a - b;

        return c;
    }

    /**
     * @dev Returns the multiplication of two unsigned integers, reverting on
     * overflow.
     *
     * Counterpart to Solidity's `*` operator.
     *
     * Requirements:
     * - Multiplication cannot overflow.
     */
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
        // benefit is lost if 'b' is also tested.
        // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
        if (a == 0) {
            return 0;
        }

        uint256 c = a * b;
        require(c / a == b, "SafeMath: multiplication overflow");

        return c;
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, "SafeMath: division by zero");
        uint256 c = a / b;
        // assert(a == b * c + a % b); // There is no case in which this doesn't hold

        return c;
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     */
    function mod(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b != 0, "SafeMath: modulo by zero");
        return a % b;
    }
}

contract BillOfSale {
    using SafeMath for uint256;
    
    address public buyer;
	address public seller;
	address public arbiter;
	string public descr;
	uint256 public price;
	
	uint256 private arbiterFee;
	uint256 private buyerAward;
    uint256 private sellerAward;
	
	enum State { Created, Confirmed, Disputed, Resolved, Complete }
	State public state;
	
	event Confirmed(address indexed buyer, address indexed this);
	event Disputed();
	event Resolved(address indexed this, address indexed buyer, address indexed seller);
	event Received(address indexed this, address indexed seller);
	
	constructor(
	    string memory _descr, 
	    uint256 _price,
	    address _buyer,
    	address _seller, 
    	address _arbiter,
    	uint256 _arbiterFee) 
    	    public {
    	            descr = _descr;
            	    price = _price;
            	    seller = _seller;
            	    buyer = _buyer;
            	    arbiter = _arbiter;
            	    arbiterFee = _arbiterFee;
	                 }
                     /**
                      * @dev Throws if called by any account other than the buyer.
                      */
                        modifier onlyBuyer() {
                        require(msg.sender == buyer);
                         _;
                           }
                        modifier onlyBuyerOrSeller() {
                        require(
                        msg.sender == buyer ||
                        msg.sender == seller);
                         _;
                           }
                        modifier onlyArbiter() {
                        require(msg.sender == arbiter);
                         _;
                           }
	                    modifier inState(State _state) {
    	                require(state == _state);
                    	 _;
	                       }
	                        function confirmPurchase() public payable onlyBuyer inState(State.Created) {
    	                      require(price == msg.value);
    	                      state = State.Confirmed;
    	                      emit Confirmed(buyer, address(this));
	                        }
	                        function confirmReceipt() public onlyBuyer inState(State.Confirmed) {
	                          state = State.Complete;
	                          seller.transfer(address(this).balance);
	                          emit Received(address(this), seller);
	                        }
	                        function initiateDispute() public onlyBuyerOrSeller inState(State.Confirmed) {
	                          state = State.Disputed;
    	                      emit Disputed();
                            }
                            function resolveDispute(uint256 _buyerAward, uint256 _sellerAward) public onlyArbiter inState(State.Disputed) {
	                          state = State.Resolved;
	                          buyerAward = _buyerAward;
	                          sellerAward = _sellerAward;
	                          buyer.transfer(buyerAward);
	                          seller.transfer(sellerAward);
	                          arbiter.transfer(arbiterFee);
                              emit Resolved(address(this), buyer, seller);
                            }
}

contract BillOfSaleFactory {

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

  function getDeployedContracts() public view returns (address[] memory)
  {
    return contracts;
  }

  // deploy a new contract

  function newBillOfSale(
      string memory _descr, 
	  uint256 _price,
      address _buyer,
      address _seller, 
      address _arbiter,
      uint256 _arbiterFee)
          public
          returns(address)
   {
    BillOfSale c = new BillOfSale(
        _descr, 
        _price, 
        _buyer, 
        _seller,
        _arbiter,
        _arbiterFee);
            validContracts[c] = true;
            contracts.push(c);
            return c;
    }
}
