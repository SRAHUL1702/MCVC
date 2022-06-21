pragma solidity >^0.4.24;

contract Collector{
    address owner;

 modifier onlyCollector(){
    if(msg.sender!=owner) throw;
    _
 }
mapping(string=>detailsForRegistration) records;
mapping(string=>bool) validate;

function addHospital(string memory n,string memory exp) public{
    bool check=validate[n];
    require(!check,"sorry this hospital is already register");
    detailsForRegistration storage details=records[n];
    details.name=n;
    details.successfulCheckup=0;
    details.failureCheckup=0;
    details.experise=exp; 
    validate[n]=true;
    }
}
}
