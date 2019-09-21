pragma solidity 0.5.3;

contract DigitalSecretary {
    
    uint256 public entityFilings;
    
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
