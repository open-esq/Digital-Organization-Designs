pragma solidity 0.4.26;

contract BillOfSale {
	address public seller;
	address public buyer;
	address public arbiter;
	string public descr;
	uint256 public price;
	enum State { Created, Locked, Inactive }
	State public state;
	
	event Confirmed(address indexed buyer, address indexed this);
	event Disputed(address indexed this, address indexed arbiter);
	event Received(address indexed this, address indexed seller);
	
	constructor(
	    string memory _descr, 
	    uint256 _price,
    	address _seller, 
    	address _buyer,
    	address _arbiter) 
    	    public {
    	            descr = _descr;
            	    price = _price;
            	    seller = _seller;
            	    buyer = _buyer;
            	    arbiter = _arbiter;
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
	                    modifier inState(State _state) {
    	                require(state == _state);
                    	 _;
	                       }
	                        function confirmPurchase() public payable onlyBuyer inState(State.Created) {
    	                      require(price == msg.value);
    	                      state = State.Locked;
    	                      emit Confirmed(buyer, address(this));
	                        }
	                        function dispute() public onlyBuyerOrSeller inState(State.Locked) {
	                          state = State.Inactive;
    	                      arbiter.transfer(address(this).balance);
    	                      emit Disputed(address(this), arbiter);
                            }
	                        function confirmReceipt() public onlyBuyer inState(State.Locked) {
	                          state = State.Inactive;
	                          seller.transfer(address(this).balance);
	                          emit Received(address(this), seller);
	                        }
}
