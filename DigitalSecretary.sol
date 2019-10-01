pragma solidity 0.5.3;

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

contract SecretaryRole {
    using Roles for Roles.Role;

    event SecretaryAdded(address indexed account);
    event SecretaryRemoved(address indexed account);

    Roles.Role private _secretaries;

    constructor () internal {
        _addSecretary(msg.sender);
    }

    modifier onlySecretary() {
        require(isSecretary(msg.sender), "SecretaryRole: caller does not have the Secretary role");
        _;
    }

    function isSecretary(address account) public view returns (bool) {
        return _secretaries.has(account);
    }

    function addSecretary(address account) public onlySecretary {
        _addSecretary(account);
    }

    function renounceSecretary() public {
        _removeSecretary(msg.sender);
    }

    function _addSecretary(address account) internal {
        _secretaries.add(account);
        emit SecretaryAdded(account);
    }

    function _removeSecretary(address account) internal {
        _secretaries.remove(account);
        emit SecretaryRemoved(account);
    }
}

contract DigitalSecretary is SecretaryRole {
    using SafeMath for uint256;
    
    uint256 public entityFilings; // tallies number of successful entity registration calls
    uint256 public filingFeeAmount; // filing fee amount adjustable by secretary / default wei amount: "50000000000000000000"
    address public feeTokenAddress; // fee token address for paying filing and other administration fees / default testnet: "0x8ad3aa5d5ff084307d28c8f514d7a193b2bfe725"
    address public secretary; // administrator of digital secretary contract
    address public treasuryAddress; // receives filing and other administrative fees generated by digital secretary
    
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
        string filingDetails; // could be IPFS hash, plaintext, or JSON detailing articles or certificate of incorporation
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
    
	/**
     * @dev Sets the initial values for `filingFeeAmount`, `feeTokenAddress`, `treasuryAddress`. 
     */
    constructor (uint256 _filingFeeAmount, address _feeTokenAddress, address _treasuryAddress) public {
        filingFeeAmount = _filingFeeAmount;
        feeTokenAddress = _feeTokenAddress;
        secretary = msg.sender;
        treasuryAddress = _treasuryAddress; 
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
        
        require(feeToken.transferFrom(msg.sender, address(secretary), filingFeeAmount));
        
        Kind(entityKind);
        Type(entityType);
        
        uint256 fileNumber = entityFilings.add(1); // tallies from running total
        uint256 filingDate = block.timestamp; // "now"
        uint256 feesPaid = filingFeeAmount; // pushes fee amount to entity tally
        bool goodStanding = true; // default value for new entity
        
        entityFilings = entityFilings.add(1); // tallies new filing to running total
            
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
    
    /***************
    TREASURY MGMT 
    ***************/
    // digital secretary can update entity filing fee amount   
    function updateFilingFee(uint256 _filingFeeAmount) public onlySecretary {
        filingFeeAmount = _filingFeeAmount;
    }
    
    // digital secretary can update entity fee token address   
    function updateFeeTokenAddress(address _feeTokenAddress) public onlySecretary {
        feeTokenAddress = _feeTokenAddress;
    }
    
    // digital secretary can update entity filing fee amount   
    function updateTreasuryAddress(address _treasuryAddress) public onlySecretary {
        treasuryAddress = _treasuryAddress;
    }
    
    /***************
    ENTITY MGMT 
    ***************/
    // digital secretary can update entity name   
    function updateEntityName(uint256 fileNumber, string memory newName) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.entityName = newName; 
    }
    
    // digital secretary can update registered agent details  
    function updateRegisteredAgent(uint256 fileNumber, string memory registeredAgentdetails) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.registeredAgentdetails = registeredAgentdetails; 
    }
    
    // digital secretary can convert entity kind   
    function convertEntityKind(uint256 fileNumber, uint8 newKind) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.entityKind = newKind; 
    }
    
    // digital secretary can convert entity type   
    function convertEntityType(uint256 fileNumber, uint8 newType) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.entityType = newType; 
    }
    
    // digital secretary can convert entity domicile   
    function convertEntityDomicile(uint256 fileNumber, bool domestic) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.domestic = domestic; 
    }

    // digital secretary can convert entity standing   
    function convertEntityStanding(uint256 fileNumber, bool goodStanding) public onlySecretary {
        Entity storage entity = entities[fileNumber];
        entity.goodStanding = goodStanding; 
    }
}
