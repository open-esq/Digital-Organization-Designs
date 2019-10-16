/*
|| THE LEXDAO REGISTRY (TLDR) || version 0.1

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
OPENZEPPELIN REFERENCE CONTRACTS - SafeMath, ScribeRole, ERC-20 transactional scripts
***************/
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
        return sub(a, b, "SafeMath: subtraction overflow");
    }

    /**
     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
     * overflow (when the result is negative).
     *
     * Counterpart to Solidity's `-` operator.
     *
     * Requirements:
     * - Subtraction cannot overflow.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b <= a, errorMessage);
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
        // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
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
        return div(a, b, "SafeMath: division by zero");
    }

    /**
     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
     * division by zero. The result is rounded towards zero.
     *
     * Counterpart to Solidity's `/` operator. Note: this function uses a
     * `revert` opcode (which leaves remaining gas untouched) while Solidity
     * uses an invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        // Solidity only automatically asserts when dividing by 0
        require(b > 0, errorMessage);
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
        return mod(a, b, "SafeMath: modulo by zero");
    }

    /**
     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
     * Reverts with custom message when dividing by zero.
     *
     * Counterpart to Solidity's `%` operator. This function uses a `revert`
     * opcode (which leaves remaining gas untouched) while Solidity uses an
     * invalid opcode to revert (consuming all remaining gas).
     *
     * Requirements:
     * - The divisor cannot be zero.
     *
     * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
     * @dev Get it via `npm install @openzeppelin/contracts@next`.
     */
    function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
        require(b != 0, errorMessage);
        return a % b;
    }
}

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
contract lexDAORegistry is ScribeRole { // TLDR: internet-native market to wrap and enforce common transaction patterns with legal and ethereal security
    using SafeMath for uint256;
    
    // lexDAO references for lexDAOscribe (lexScribe) reputation governance fees
	address payable public lexDAO;
	
	// lexToken ERC-20 token references for public inspection
	string public name;
	string public symbol;
	uint8 public decimals;
	uint256 public totalSupply;
	
	// counters for lexScribe lexScriptWrapper and registered DDR (rddr) / DC (rdc)
	uint256 public LSW = 1; // number of lexScriptWrapper enscribed 
	uint256 public RDC; // number of rdc
	uint256 public RDDR; // number of rrdr 
	
    // mapping for lexScribe reputation governance program
    mapping(address => uint256) public reputation; // mapping lexScribe reputation points 
    mapping (address => uint256) public balanceOf; // mapping lexscribe LEX token awards for contributions
    mapping(address => uint256) public lastActionTimestamp; // mapping lexScribe governance actions (cooldown)
    mapping(address => uint256) public lastSuperActionTimestamp; // mapping special lexScribe governance actions (icedown)
    
    // mapping for stored lexScript wrappers and registered digital dollar retainers (DDR / rddr)
    mapping (uint256 => lexScriptWrapper) public lexScript; // mapping registered lexScript 'wet code' templates
    mapping (uint256 => DC) public rdc; // mapping rdc call numbers for inspection and signature revocation
    mapping (uint256 => DDR) public rddr; // mapping rddr call numbers for inspection and digital dollar payments
	
    struct lexScriptWrapper { // LSW: rddr lexScript templates maintained by lexScribes
            address lexScribe; // lexScribe (0x) address that enscribed lexScript template into TLDR / can make subsequent edits (lexVersion)
            address lexAddress; // (0x) address to receive lexScript wrapper lexFee / adjustable by associated lexScribe
            string templateTerms; // lexScript template terms to wrap rddr with legal security
            uint256 lexID; // number to reference in rddr to import lexScript wrapper
            uint256 lexVersion; // version number to mark lexScribe edits
            uint256 lexRate; // fixed, divisible rate for lexFee in ddrToken type per rddr payment made thereunder / e.g., 100 = 1% lexFee on rddr payDDR payment transaction
        }
        
    struct DC { // Digital Covenant lexScript templates maintained by lexScribes
        	address signatory; // DC signatory (0x) address
        	string templateTerms; // DC templateTerms derived from referenced lexScriptWrapper
        	uint256 dcNumber; // DC number generated on covenant registration / identifies DC for revocation function calls
        	uint256 lexID; // lexID number reference to include lexScriptWrapper for legal security / default '0' for generalized rddr lexScript template
        	uint256 timeStamp; // block.timestamp ("now") of DC registration 
        	bool revoked; // tracks signature revocation status 
    	}
    	
	struct DDR { // Digital Dollar Retainers created on lexScript terms maintained by lexScribes
        	address client; // rddr client (0x) address
        	address provider; // provider (0x) address that receives ERC-20 payments in exchange for goods or services
        	IERC20 ddrToken; // ERC-20 digital token (0x) address used to transfer digital value on ethereum under rddr / e.g., DAI 'digital dollar' - 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359
        	string deliverable; // goods or services (deliverable) retained for benefit of ethereum payments
        	string governingLawForum; // choice of law and forum for retainer relationship (or similar legal wrapper/context description)
        	uint256 ddrNumber; // rddr number generated on DDR registration / identifies rddr for payDDR function calls
        	uint256 lexID; // lexID number reference to include lexScriptWrapper reference for legal security / default '1' for generalized rddr lexScript template
        	uint256 timeStamp; // block.timestamp ("now") of registration used to calculate retainerTermination UnixTime
        	uint256 retainerTermination; // termination date of rddr in UnixTime / locks payments to provider / allows withdrawal of remaining escrow digital value by client on payDDR function
        	uint256 deliverableRate; // value rate for rddr deliverables in digital dollar wei amount / 1 = 1000000000000000000
        	uint256 paid; // tracking amount of designated ERC-20 digital value paid under rddr in wei amount for payCap logic
        	uint256 payCap; // cap limit on rddr payments in wei amount 
        	bool disputed; // tracks digital dispute status from client or provider / if called, locks rddr payments for reputable lexScribe resolution
    	}
    	
	constructor(string memory tldrTerms, uint256 tldrLexRate, address tldrLexAddress, address payable tldrLexDAO) public { // deploys TLDR contract with designated lexRate and lexAddress (0x) and stores base lexScript template "1" (lexID)
	        address lexScribe = msg.sender; // TLDR summoner is lexScribe
	        reputation[msg.sender] = 3; // sets TLDR summoner lexScribe reputation to '3' max value on construction
	        lexDAO = tldrLexDAO; // lexDAO (0x) address as constructed
	        uint256 lexID = 1; // default lexID for constructor / general rddr reference
	        uint256 lexVersion = 0; // default lexID for constructor / general rddr reference
	        lexScript[lexID] = lexScriptWrapper( // populate default '1' lexScript data for reference in LSW and rddr
                	lexScribe,
                	tldrLexAddress,
                	tldrTerms,
                	lexID,
                	lexVersion,
                	tldrLexRate);
        }
        
    // TLDR Contract Events
    event Enscribed(uint256 indexed lexID, uint256 indexed lexVersion, address indexed lexScribe); // triggered on successful LSW creation / edits to LSW
    event Signed(uint256 indexed lexID, uint256 indexed dcNumber, address indexed signatory); // triggered on successful lexScript creation / edits to LSW 
	event Registered(uint256 indexed ddrNumber, uint256 indexed lexID); // triggered on successful rddr 
	event Paid(uint256 indexed ddrNumber, uint256 indexed lexID); // triggered on successful rddr payments
	event Transfer(address indexed from, address indexed to, uint256 value); // IERC20 logic / triggered on successful LEX mint / transfers
    
    /***************
    TLDR GOVERNANCE FUNCTIONS
    ***************/
    // restricts lexScribe TLDR reputation governance function calls to once per day (cooldown)
    modifier cooldown() {
            require(now.sub(lastActionTimestamp[msg.sender]) > 1 days); // programs cooldown period
            _;
            lastActionTimestamp[msg.sender] = now; // block.timestamp, "now"
        }
        
    // restricts lexScribe TLDR reputation (super) staking and lexDAO governance function calls to once per 120 days (icedown)
    modifier icedown() {
            require(now.sub(lastSuperActionTimestamp[msg.sender]) > 90 days); // programs icedown period
            _;
            lastSuperActionTimestamp[msg.sender] = now; // block.timestamp, "now"
        }
        
    // lexScribes can stake ether (Ξ) value for TLDR reputation and special TLDR function access (TLDR-write privileges, ethereal dispute resolution) 
    function stakeReputationETH() payable public onlyScribe icedown {
            require(msg.value == 0.1 ether); // tenth of ether (Ξ) for staking reputation to lexDAO
            reputation[msg.sender] = 3; // sets / refreshes lexScribe reputation to '3' max value
            address(lexDAO).transfer(msg.value); // forwards staked value (Ξ) to designated lexDAO (0x) address
        }
        
    // public check on lexScribe reputation status
    function isReputable(address x) public view returns (bool) { // returns true if lexScribe is reputable
            return reputation[x] > 0;
        }
        
    // reputable lexScribes can reduce each other's reputation within cooldown period 
    function reduceScribeRep(address reducedLexScribe) cooldown public {
            require(isReputable(msg.sender)); // program governance check / lexScribe must be reputable
            require(msg.sender != reducedLexScribe); // program governance check / cannot reduce own reputation
            reputation[reducedLexScribe] = reputation[reducedLexScribe].sub(1); // reduce lexScribe reputation by "1"
        }
        
    // reputable lexScribes can repair each other's reputation within cooldown period
    function repairScribeRep(address repairedLexScribe) cooldown public {
            require(isReputable(msg.sender)); // lexScribe must be reputable
            require(msg.sender != repairedLexScribe); // program governance check / cannot repair own reputation
            require(reputation[repairedLexScribe] < 3); // program governance check / cannot repair fully reputable lexScribe
            require(reputation[repairedLexScribe] > 0); // program governance check / cannot repair disreputable lexScribe / induct non-staked lexScribe
            reputation[repairedLexScribe] = reputation[repairedLexScribe].add(1); // repair reputation by "1"
        }
    
    // fully reputable lexScribe can update beneficiary lexDAO (0x) address for reputation governance stakes (Ξ) within icedown period
    function updatelexDAO(address payable newlexDAO) icedown public {
            require(newlexDAO != address(0)); // program safety check / newlexDAO cannot be "0" burn address
            require(reputation[msg.sender] == 3); // program governance check / only fully reputable lexScribes can update lexDAO (0x) address
            lexDAO = newlexDAO; // update lexDAO (0x) address
        }
        
    /***************
    LEXSCRIBE FUNCTIONS
    ***************/
    // reputable lexScribes can register lexScript legal wrappers on TLDR and program ERC-20 lexFees associated with lexID / receive LEX award
	function writeLexScript(string memory templateTerms, uint256 lexRate, address lexAddress) public {
	        require(isReputable(msg.sender)); // program governance check / lexScribe must be reputable 
	        uint256 lexID = LSW.add(1); // reflects new lexScript value for tracking lexScript wrappers
	        uint256 lexVersion = 0; // initalized lexVersion, "0"
	        LSW = LSW.add(1); // counts new entry to LSW 
	    
	        lexScript[lexID] = lexScriptWrapper( // populate lexScript data for reference in rddr
                	msg.sender,
                	lexAddress,
                	templateTerms,
                	lexID,
                	lexVersion,
                	lexRate);
            
            emit Enscribed(lexID, lexVersion, msg.sender); 
            
            // native ERC-20 LEX token award for contributed lexScript, "work"
            name = "lexDAO";
            symbol = "LEX";
            uint256 mintAmount = 10000000000000000000;
            decimals = 18;
            balanceOf[msg.sender] = mintAmount;
            totalSupply = totalSupply.add(mintAmount);

            emit Transfer(address(0), msg.sender, totalSupply);
	    }
	    
	// lexScribes can update TLDR lexScript wrappers with new templateTerms and (0x) newLexAddress / automatically versions up LSW
	function editLexScript(uint256 lexID, string memory templateTerms, address lexAddress) public {
	        lexScriptWrapper storage lS = lexScript[lexID]; // retrieve rdc data
	        require(address(msg.sender) == lS.lexScribe); // program safety check / authorization
	        uint256 lexVersion = lS.lexVersion.add(1); // updates lexVersion 
	    
	        lexScript[lexID] = lexScriptWrapper( // populate updated lexScript data for reference in rddr
                	msg.sender,
                	lexAddress,
                	templateTerms,
                	lexID,
                	lexVersion,
                	lS.lexRate);
                	
            emit Enscribed(lexID, lexVersion, msg.sender);
    	}
    	
    /***************
    MARKET FUNCTIONS
    ***************/
    // public can sign and associate (0x) with lexScript digital covenant wrapper 
	function signDC(uint256 lexID) public { // sign Digital Covenant with (0x) address
	        lexScriptWrapper storage lS = lexScript[lexID]; // retrieve LSW data
	        uint256 dcNumber = RDC.add(1); // reflects new rdc value for public inspection and signature revocation
	        bool revoked = false; // initialized value of Digital Covenant, "false"
	        RDC = RDC.add(1); // counts new entry to RDC
	        
	        rdc[dcNumber] = DC( // populate rdc data
                	msg.sender,
                	lS.templateTerms,
                	dcNumber,
                	lexID,
                	now,
                	revoked);
                	
            emit Signed(lexID, dcNumber, msg.sender);
    	}
    	
    // registered DC signatories can revoke (0x) signature  
	function revokeDC(uint256 dcNumber) public { // revoke Digital Covenant signature with (0x) address
	        DC storage dc = rdc[dcNumber]; // retrieve rdc data
	        require(address(msg.sender) == dc.signatory); // program safety check / authorization
	    
	        rdc[dcNumber] = DC(// update rdc data
                	msg.sender,
                	"Signature Revoked", // replace Digital Covenant template with revocation message
                	dc.dcNumber,
                	dc.lexID,
                	now,
                	true);
                	
            emit Signed(dc.lexID, dcNumber, msg.sender);
    	}
    
	// public can register DDR with TLDR lexScripts (lexID) 
	function registerDDR( // rddr 
    	    address client,
    	    address provider,
    	    IERC20 ddrToken,
    	    string memory deliverable,
    	    string memory governingLawForum,
    	    uint256 retainerDuration,
    	    uint256 deliverableRate,
    	    uint256 payCap,
    	    uint256 lexID) public {
    	    require(lexID != (0)); // program safety check
            require(deliverableRate <= payCap); // program safety check / economics
            uint256 ddrNumber = RDDR.add(1); // reflects new rddr value for inspection and digital payments
            uint256 retainerTermination = now.add(retainerDuration); // rddr termination date in UnixTime, "now" block.timestamp + retainerDuration
            ddrToken.transferFrom(client, address(this), payCap); // escrows payCap amount in approved ddrToken into TLDR for rddr payments and/or resolution
        	RDDR = RDDR.add(1); // counts new entry to RDDR
    
        	rddr[ddrNumber] = DDR( // populate rddr data 
                	client,
                	provider,
                	ddrToken,
                	deliverable,
                	governingLawForum,
                	ddrNumber,
                	lexID,
                	now, // block.timestamp, "now"
                	retainerTermination,
                	deliverableRate,
                	0,
                	payCap,
                	false);
        	 
            emit Registered(ddrNumber, lexID); 
        }
    
    // rddr parties can initiate dispute and lock escrowed remainder of rddr payCap in TLDR until resolution by reputable lexScribe
    function disputeDDR(uint256 ddrNumber) public {
            DDR storage ddr = rddr[ddrNumber]; // retrieve rddr data
            require(ddr.disputed == false); // program safety check / status
            require (now <= ddr.retainerTermination); // program safety check / time
            require(msg.sender == ddr.client || msg.sender == ddr.provider); // program safety check / authorization
            ddr.disputed = true; // updates DDR value to reflect dispute status, "true"
        }
    
    // reputable lexScribe can resolve rddr dispute with division of remaining payCap amount (e.g., 2 = 50%), claim 5% fee
    function resolveDDR(uint256 ddrNumber, uint8 clientAwardRate, uint8 providerAwardRate) public {
            DDR storage ddr = rddr[ddrNumber]; // retrieve rddr data
            require(msg.sender != ddr.client); // program safety check / authorization / client cannot resolve own dispute as lexScribe
            require(msg.sender != ddr.provider); // program safety check / authorization / provider cannot resolve own dispute as lexScribe
            require(isReputable(msg.sender)); // program governance check / arbitrating lexScribe must be reputable
            uint256 resolutionFee = ddr.payCap.sub(ddr.paid).div(20); // calculates 5% lexScribe dispute resolution fee
            uint256 resolutionRate = ddr.payCap.sub(ddr.paid).sub(resolutionFee); // calculates resolution fee from rddr payCap remainder
            ddr.ddrToken.transfer(ddr.client, resolutionRate.div(clientAwardRate)); // executes ERC-20 transfer to rddr client
            ddr.ddrToken.transfer(ddr.provider, resolutionRate.div(providerAwardRate)); // executes ERC-20 transfer to rddr provider
    	    ddr.ddrToken.transfer(msg.sender, resolutionFee); // executes ERC-20 transfer of resolution fee to resolving lexScribe
        }
    
    // pay rddr on TLDR
	function payDDR(uint256 ddrNumber) public { // forwards approved ddrToken deliverableRate amount to provider (0x) address / lexFee for attached lexID lexAddress
    	    DDR storage ddr = rddr[ddrNumber]; // retrieve rddr data
    	    require(ddr.disputed == false); // program safety check / dispute status
    	    lexScriptWrapper storage lS = lexScript[ddr.lexID]; // retrieve LSW data
    	    require(now <= ddr.retainerTermination); // program safety check / time
    	    require(address(msg.sender) == ddr.client); // program safety check / authorization
    	    require(ddr.paid.add(ddr.deliverableRate) <= ddr.payCap); // program safety check / economics
    	    uint256 lexFee = ddr.deliverableRate.div(lS.lexRate); // derive lexFee from transaction value
    	    if (now >= ddr.retainerTermination) { // *if* retainerDuration has terminated, client can reclaim payCap remainder ERC-20 balance from escrow
    	    uint256 remainder = ddr.payCap.sub(ddr.paid); // derive rddr remainder
    	    ddr.ddrToken.transfer(ddr.client, remainder); // withdraws remainder of rddr escrow amount to client after termination 
    	    ddr.ddrToken.transferFrom(ddr.client, lS.lexAddress, lexFee); // executes ERC-20 transfer of lexFee to (0x) lexAddress identified in lexID   
    	    }
    	    ddr.ddrToken.transfer(ddr.provider, ddr.deliverableRate); // executes ERC-20 transfer to rddr provider
    	    ddr.ddrToken.transferFrom(ddr.client, lS.lexAddress, lexFee); // executes ERC-20 transfer of lexFee to (0x) lexAddress identified in lexID
    	    ddr.paid = ddr.paid.add(ddr.deliverableRate); // tracks total ERC-20 wei amount paid under rddr 
        	emit Paid(ddr.ddrNumber, ddr.lexID); 
    	}
}
