pragma solidity 0.5.3;

interface IERC20 {
	/**
 	* @dev Returns the amount of tokens in existence.
 	*/
	function totalSupply() external view returns (uint256);

	/**
 	* @dev Returns the amount of tokens owned by `account`.
 	*/
	function balanceOf(address account) external view returns (uint256);

	/**
 	* @dev Moves `amount` tokens from the caller's account to `recipient`.
 	*
 	* Returns a boolean value indicating whether the operation succeeded.
 	*
 	* Emits a {Transfer} event.
 	*/
	function transfer(address recipient, uint256 amount) external returns (bool);

	/**
 	* @dev Returns the remaining number of tokens that `spender` will be
 	* allowed to spend on behalf of `owner` through {transferFrom}. This is
 	* zero by default.
 	*
 	* This value changes when {approve} or {transferFrom} are called.
 	*/
	function allowance(address owner, address spender) external view returns (uint256);

	/**
 	* @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
 	*
 	* Returns a boolean value indicating whether the operation succeeded.
 	*
 	* IMPORTANT: Beware that changing an allowance with this method brings the risk
 	* that someone may use both the old and the new allowance by unfortunate
 	* transaction ordering. One possible solution to mitigate this race
 	* condition is to first reduce the spender's allowance to 0 and set the
 	* desired value afterwards:
 	* https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
 	*
 	* Emits an {Approval} event.
 	*/
	function approve(address spender, uint256 amount) external returns (bool);

	/**
 	* @dev Moves `amount` tokens from `sender` to `recipient` using the
 	* allowance mechanism. `amount` is then deducted from the caller's
 	* allowance.
 	*
 	* Returns a boolean value indicating whether the operation succeeded.
 	*
 	* Emits a {Transfer} event.
 	*/
	function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

	/**
 	* @dev Emitted when `value` tokens are moved from one account (`from`) to
 	* another (`to`).
 	*
 	* Note that `value` may be zero.
 	*/
	event Transfer(address indexed from, address indexed to, uint256 value);

	/**
 	* @dev Emitted when the allowance of a `spender` for an `owner` is set by
 	* a call to {approve}. `value` is the new allowance.
 	*/
	event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DigitalSecretary {
    
    uint256 public entityFilings; // tallies number of successful entity registration calls
    address public feeTokenAddress = 0x8ad3aA5d5ff084307d28C8f514D7a193B2Bfe725; // RinkebyDAI / thanks Paul Berg!
    uint256 public feeAmount = 50000000000000000000; // "50" filing fee amount 
    address public secretary = msg.sender; // creator of contract is default secretary to receive fees
    
    mapping (uint256 => Entity) public entities; // mapping registered entities to filing numbers
    
    event entityRegistered(uint256 fileNumber, uint256 filingDate, string entityName, uint8 entityKind, bool domestic);
    
    struct Entity {
        uint256 fileNumber; // latest successful registration function call
        uint256 filingDate; // blocktime of successful registration function call
        string entityName; // Full Legal Name / e.g., "ACME LLC"
        uint8 entityKind; // see below enum / default, '3' - "LLC"
        uint8 entityType; // see below enum / default, '1' - "General"
        bool domestic; // default "true"
        string registeredAgentdetails; // could be IPFS hash, plaintext, or JSON detailing registered agent
        string filingDetails; // could be IPFS hash, plaintext, or JSON presenting articles or certificate of incorporation
        uint256 feesPaid; // running tally of fees paid to digital secretary by registered entity
        bool goodStanding; // default "true" on successful registration function call
        }
      
    // compare: Delaware resource: https://icis.corp.delaware.gov/Ecorp/FieldDesc.aspx#ENTITY%20TYPE 
    enum Kind {
        CORP,
        LP,
        LLC,
        TRUST,
        PARTNERSHIP,
        UNPA
    }
    
    // compare: Delaware resource: https://icis.corp.delaware.gov/Ecorp/FieldDesc.aspx#ENTITY%20TYPE
    enum Type {
        GENERAL,
        BANK,
        CLOSED,
        DISC,
        PA,
        GP,
        RIC,
        LLP,
        NT,
        NP,
        STOCK
    }
    
    // restricts certain functions to digital secretary
    modifier onlySecretary {
    	require(msg.sender == secretary);
    	_;
	}
    
    // public function to register entity with digital secretary 
    function registerEntity(
        string memory entityName,
        uint8 entityKind,
        uint8 entityType,
        bool domestic,
        string memory registeredAgentdetails,
        string memory filingDetails) public {
            
        IERC20 feeToken = IERC20(feeTokenAddress);
        
        assert(feeToken.transferFrom(msg.sender, address(secretary), feeAmount));
        
        Kind(entityKind);
        Type(entityType);
        
        uint256 fileNumber = entityFilings + 1; // tallies from running total
        uint256 filingDate = block.timestamp; // now
        uint256 feesPaid = feeAmount; // pushes fee amount to entity tally
        bool goodStanding = true; // default value for new entity
        
        entityFilings = entityFilings + 1; // tallies new filing to running total
            
        entities[fileNumber] = Entity(
            fileNumber,
            filingDate,
            entityName,
            entityKind,
            entityType,
            domestic,
            registeredAgentdetails,
            filingDetails,
            feesPaid,
            goodStanding);
            
            emit entityRegistered(fileNumber, filingDate, entityName, entityKind, domestic);
        }
    
    // digital secretary can reduce entity standing for non-compliance  
    function reduceStanding(uint256 fileNumber) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.goodStanding = false; 
    }
    
    // digital secretary can repair entity standing upon compliance  
    function repairStanding(uint256 fileNumber) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.goodStanding = true; 
    }
}
