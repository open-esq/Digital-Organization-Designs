pragma solidity 0.5.9;

contract Retainer {
    
    address payable public beneficiary; // address that receives retainer fees
    uint256 public fee; // wei amount of retainer fees
    
    event Retained(address indexed, address indexed this); // triggered on retainer fee success
    
    modifier onlyBeneficiary() // restricts retainer fee and beneficiary updating functions to beneficiary address
    {
        require(
            msg.sender == beneficiary,
            "Sender not authorized."
        );
        _;
    }
    
    constructor(uint256 _fee) public { // initializes contract with retainer fee amount
        beneficiary = msg.sender;
        fee = _fee;
    }

    function payRetainerFee() public payable { // allows public to pay retainer fee
        require(msg.value == fee);
        beneficiary.transfer(msg.value);
        emit Retained(msg.sender, address(this));
    }
    
    // Beneficiary can administrate Retainer Letter 
    
    function updateFee(uint256 newFee) public onlyBeneficiary { // changes fee amount for retainers
        fee = newFee;
    }
    
    function assignBeneficiary(address payable newBeneficiary) public onlyBeneficiary { // changes beneficiary address
        beneficiary = newBeneficiary;
    }
}
