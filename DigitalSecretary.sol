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
    
    uint256 public entityFilings;
    address public feeTokenAddress = 0x8ad3aA5d5ff084307d28C8f514D7a193B2Bfe725;
    uint256 public feeAmount = 500000000000000000000;
    address public secretary = msg.sender;
    
    mapping (uint256 => Entity) public entities;
    
    event entityRegistered(uint256 fileNumber, uint256 filingDate, string entityName, uint8 entityKind, bool domestic);
    
    struct Entity {
        uint256 fileNumber; // established by succesful registration function call
        uint256 filingDate; // established by blocktime of succesful registration function call
        string entityName; // Full Legal Name / e.g., ACME LLC
        uint8 entityKind; // see below enum / default, '3' - LLC
        uint8 entityType; // see below enum / default, '1' - General
        bool domestic; // default "true"
        string registeredAgentinfo; // could be IPFS hash, plaintext, or JSON
        string filingDetails; // could be IPFS hash, plaintext, or JSON 
        bool goodStanding; // established "true" on succesful registration function call
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
    
    // call to establish digital entity registration record / 
    function registerEntity(
        string memory entityName,
        uint8 entityKind,
        uint8 entityType,
        bool domestic,
        string memory registeredAgentinfo,
        string memory filingDetails) public {
            
        IERC20 feeToken = IERC20(feeTokenAddress);
        
        assert(feeToken.transferFrom(msg.sender, address(secretary), feeAmount));
        
        Kind(entityKind);
        Type(entityType);
        
        uint256 fileNumber = entityFilings + 1;
        uint256 filingDate = block.timestamp; // now
        bool goodStanding = true;
        
        entityFilings = entityFilings + 1;
            
        entities[fileNumber] = Entity(
            fileNumber,
            filingDate,
            entityName,
            entityKind,
            entityType,
            domestic,
            registeredAgentinfo,
            filingDetails,
            goodStanding);
            
            emit entityRegistered(fileNumber, filingDate, entityName, entityKind, domestic);
        }
}
