pragma solidity >=0.4.0 <0.7.0;

contract DelawareCorporation {

    struct DateTime {
        uint16 year;
        uint8 month;
        uint8 day;
        uint8 hour;
        uint8 minute;
        uint8 second;
        uint8 weekday;
    }
    
    struct MailingAddress {
        string line1;
        string line2;
        string attn;
        string city;
        string state;
        string zip;
    }
    
    enum EntityType {naturalPerson, legalEntity}
    
    struct irlContract {
        string name;
        Entity[] parties;
        string description;
        uint id;
        string[] contents;
        uint category;
        DateTime executionDate;
    }
    
    struct Entity {
        EntityType entityType;
        string name;
        string jxnOfIncorp;
        MailingAddress entityMailingAddress;
        MailingAddress entityBusinessAddress;
        MailingAddress entityNoticeAddress;
        address entityEthAddress;
        bool accreditedInvestor;
        uint entityId;
        string email;
    }
    
    enum approvalType {board, stockholder, other}
  
    struct corporateAction {
        DateTime corporateActionDate;
        Entity[] actors;
        string actionDescription;
        string[] contents;
        approvalType[] approvals;
    }
    
    struct shareClass {
        string name;
    }
    
    struct shareCert {
        shareClass shareCertClass;
        Entity holder;
        DateTime issuanceDate;
        corporateAction[] shareCertActions;
        irlContract[] shareCertInstruments;
    }
    
    struct corporation {
        Entity incorporator;
        Entity[] boardOfDirectors;
        Entity[] advisors;
        Entity[] officers;
        irlContract[] corpContracts;
        corporateAction[] corporateActions;
        shareCert[] stockLedger;
    }
    
}
