pragma solidity 0.5.3;

interface abridgedIERC20 {
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
            
        abridgedIERC20 feeToken = abridgedIERC20(feeTokenAddress);
        
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
