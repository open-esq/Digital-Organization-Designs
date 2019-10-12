/*
|| THE LEXDAO REGISTRY (TLDR) ||

DEAR MSG.SENDER(S):

/ TLDR is a project in beta.
// Please audit and use at your own risk.
/// Entry into TLDR shall not create an attorney/client relationship.
//// Likewise, TLDR should not be construed as legal advice or replacement for professional counsel.

///// STEAL THIS C0D3SL4W 

|| lexDAO ||
~presented by Open, ESQ LLC_DAO~
*/

pragma solidity 0.5.9;

/***************
OPENZEPPELIN REFERENCE CONTRACTS - ScribeRole, ERC-20 scripts
***************/

/**
 * @title Roles
 * @dev Library for managing addresses assigned to a Role.
 */
library Roles {
    struct Role {
        mapping (address => bool) bearer;
    }

    /**
     * @dev Give an account access to this role.
     */
    function add(Role storage role, address account) internal {
        require(!has(role, account), "Roles: account already has role");
        role.bearer[account] = true;
    }

    /**
     * @dev Remove an account's access to this role.
     */
    function remove(Role storage role, address account) internal {
        require(has(role, account), "Roles: account does not have role");
        role.bearer[account] = false;
    }

    /**
     * @dev Check if an account has this role.
     * @return bool
     */
    function has(Role storage role, address account) internal view returns (bool) {
        require(account != address(0), "Roles: account is the zero address");
        return role.bearer[account];
    }
}

/*
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with GSN meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
contract Context {
    // Empty internal constructor, to prevent people from mistakenly deploying
    // an instance of this contract, which should be used via inheritance.
    constructor () internal { }
    // solhint-disable-previous-line no-empty-blocks

    function _msgSender() internal view returns (address payable) {
        return msg.sender;
    }

    function _msgData() internal view returns (bytes memory) {
        this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
        return msg.data;
    }
}

contract ScribeRole is Context {
    using Roles for Roles.Role;

    event ScribeAdded(address indexed account);
    event ScribeRemoved(address indexed account);

    Roles.Role private _Scribes;

    constructor () internal {
        _addScribe(_msgSender());
    }

    modifier onlyScribe() {
        require(isScribe(_msgSender()), "ScribeRole: caller does not have the Scribe role");
        _;
    }

    function isScribe(address account) public view returns (bool) {
        return _Scribes.has(account);
    }

    function addScribe(address account) public onlyScribe {
        _addScribe(account);
    }

    function renounceScribe() public {
        _removeScribe(_msgSender());
    }

    function _addScribe(address account) internal {
        _Scribes.add(account);
        emit ScribeAdded(account);
    }

    function _removeScribe(address account) internal {
        _Scribes.remove(account);
        emit ScribeRemoved(account);
    }
}

/**
 * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
 * the optional functions; to access them see {ERC20Detailed}.
 */
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

/***************
TLDR CONTRACT
***************/

contract lexDAORegistry is ScribeRole { // **TLDR: lexDAO-maintained legal engineering registry to wrap and enforce digital transactions with legal and ethereal security**
    
    mapping (uint256 => wetCodeWrapper) public wetCode; // **mapping registered wetCode templates**
	mapping (uint256 => DDR) public rddr; // **mapping registered rddr call numbers**

    struct wetCodeWrapper { // **Digital Dollar Retainer (DDR) wetCode templates maintained by lexDAO scribes (lexScribe)**
            address lexScribe; // **lexScribe that enscribed wetCode template into TLDR**
            string templateTerms; // **wetCode template terms to wrap DDR for legal security**
            uint256 lexID; // **ID number to reference in DDR to inherit wetCode wrapper**
            uint256 lexRate; // **lexScribe fee in ddrToken type per rddr payment made thereunder / e.g., 100 = 1% fee on rddr payDDR payment transaction** 
            address lexAddress; // **ethereum address to forward wetCode template lexScribe fees**
        } 

	struct DDR {
        	address client; // **client ethereum address**
        	address provider; // **ethereum address that receives payments in exchange for goods or services**
        	IERC20 ddrToken; // **ERC-20 digital token address used to transfer value on ethereum under rddr / e.g., DAI 'digital dollar' - 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359**
        	string deliverable; // **goods or services (deliverable) retained for benefit of ethereum payments**
        	string governingLawForum; // **choice of law and forum for retainer relationship (or similar legal description)**
        	uint256 ddrNumber; // **rddr number generated on registration / identifies rddr for payDDR calls**
        	uint256 timeStamp; // **block.timestamp of registration used to calculate retainerTermination UnixTime**
        	uint256 retainerDuration; // **duration of rddr in seconds**
        	uint256 retainerTermination; // **termination date of rddr in UnixTime**
        	uint256 deliverableRate; // **rate for rddr deliverables in digital dollar wei amount / 1 = 1000000000000000000**
        	uint256 paid; // **tracking amount of designated ERC-20 paid under rddr in wei amount**
        	uint256 payCap; // **cap in wei amount to limit payments under rddr**;
        	uint256 lexID; // **lexID number reference to include wetCodeWrapper for legal security / default '0' for general DDR wetCode template**
    	}

	constructor() public {
	        address lexScribe = msg.sender;
	        // **default wetCode legal wrapper stating general human-readable DDR terms for rddr to inherit / lexID = '0'**
	        string memory ddrTerms = "|| Establishing a digital retainer hereby as [[ddrNumber]] and acknowledging mutual consideration and agreement, Client, identified by ethereum address 0x[[client]], commits to perform under this digital payment transactional script capped at $[[payCap]] digital dollar value denominated in 0x[[ddrToken]] for benefit of Provider, identified by ethereum address 0x[[provider]], in exchange for prompt satisfaction of the following, [[deliverable]], to Client by Provider upon scripted payments set at the rate of $[[deliverableRate]] per deliverable, with such retainer relationship not to exceed [[retainerDuration]] seconds and to be governed by choice of [[governingLawForum]] law and 'either/or' arbitration rules in [[governingLawForum]]. ||";
	        uint256 lexID = 0; // **default lexID for constructor / general rddr reference**
	        uint256 lexRate = 100; // **1% lexRate**
	        address lexAddress = 0xBBE222Ef97076b786f661246232E41BE0DFf6cc4; // **Open, ESQ LLC_DAO ethereum address**
	        wetCode[lexID] = wetCodeWrapper( // **populate default '0' wetCode data for reference in WCW**
                	lexScribe,
                	ddrTerms,
                	lexID,
                	lexRate,
                	lexAddress);
        }
	
	// **counters for lexScribe wetCodeWrapper and registered DDR
	uint256 public WCW = 1; // **number of wetCodeWrappers enscribed herein**
	uint256 public RDDR; // **number of DDRs registered hereby**
	
	// **lexScribe references** //
	uint256 private lexRate; // **internal lexRate script reference**
	address private lexAddress; // **internal lexAddress script reference**

    // **TLDR Events**
    event Enscribed(uint256 indexed lexID, address indexed lexScribe);
	event Registered(uint256 indexed ddrNumber, uint256 indexed lexID, address client, address provider); // **triggered on successful registration**
	event Paid(uint256 indexed ddrNumber, uint256 indexed ratePaid, uint256 indexed totalPaid, address client); // **triggered on successful rddr payments**

    // **lexScribes can register wetCode legal wrappers on TLDR and program fees for usage**
	function writeWetCodeWrapper(string memory templateTerms) public onlyScribe {
	        address lexScribe = msg.sender;
	        uint256 lexID = WCW + 1; // **reflects new wetCode value for tracking legal wrappers**
	        WCW = WCW + 1; // counts new entry to WCW 
	    
	        wetCode[lexID] = wetCodeWrapper( // populate wetCode data for reference in rddr
                	lexScribe,
                	templateTerms,
                	lexID,
                	lexRate,
                	lexAddress);
                	
            emit Enscribed(lexID, lexScribe); 
	    }
	
	function editWetCodeWrapper(uint256 lexID, string memory newTemplateTerms, address newLexAddress) public {
	        wetCodeWrapper storage wC = wetCode[lexID];
	        require(address(msg.sender) == wC.lexScribe); // program safety check / authorization
	    
	        wetCode[lexID] = wetCodeWrapper( // populate updated wetCode data for reference in rddr
                	msg.sender,
                	newTemplateTerms,
                	lexID,
                	wC.lexRate,
                	newLexAddress);
            emit Enscribed(lexID, msg.sender);
    	}
	

	// register DDR with TLDR scripts
	function registerDDR(
    	    address client,
    	    address provider,
    	    IERC20 ddrToken,
    	    string memory deliverable,
    	    string memory governingLawForum,
    	    uint256 retainerDuration,
    	    uint256 deliverableRate,
    	    uint256 payCap,
    	    uint256 lexID) public {
            require(deliverableRate <= payCap, "registerDDR: deliverableRate cannot exceed payCap"); // **program safety check / economics**
            uint256 ddrNumber = RDDR + 1; // **reflects new rddr value for tracking payments**
            uint256 paid = 0; // **initial zero value for rddr** 
            uint256 timeStamp = now; // **block.timestamp of rddr**
            uint256 retainerTermination = timeStamp + retainerDuration; // **rddr termination date in UnixTime**
    
        	RDDR = RDDR + 1; // counts new entry to RDDR
    
        	rddr[ddrNumber] = DDR( // populate rddr data 
                	client,
                	provider,
                	ddrToken,
                	deliverable,
                	governingLawForum,
                	ddrNumber,
                	timeStamp,
                	retainerDuration,
                	retainerTermination,
                	deliverableRate,
                	paid,
                	payCap,
                	lexID);
        	 
            emit Registered(ddrNumber, lexID, client, provider); 
        }

    // pay registered DDR on TLDR-scripted terms
	function payDDR(uint256 ddrNumber) public { // **forwards approved ddrToken deliverableRate amount to provider ethereum address**
    	    DDR storage ddr = rddr[ddrNumber]; // **retrieve rddr data**
    	    wetCodeWrapper storage wC = wetCode[ddr.lexID];
    	    require (now <= ddr.retainerTermination); // **program safety check / time**
    	    require(address(msg.sender) == ddr.client); // program safety check / authorization
    	    require(ddr.paid + ddr.deliverableRate <= ddr.payCap, "payDAI: payCap exceeded"); // **program safety check / economics**
    	    uint256 lexFee = ddr.deliverableRate / wC.lexRate;
    	    ddr.ddrToken.transferFrom(msg.sender, ddr.provider, ddr.deliverableRate); // **executes ERC-20 transfer**
    	    ddr.ddrToken.transferFrom(msg.sender, wC.lexAddress, lexFee);
    	    ddr.paid = ddr.paid + ddr.deliverableRate; // **tracks amount paid under rddr**
        	emit Paid(ddr.ddrNumber, ddr.deliverableRate, ddr.paid, msg.sender); 
    	}
}
