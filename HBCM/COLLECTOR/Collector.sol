// SPDX-License-Identifier: MIT
pragma solidity >0.4.0;
contract Collector{
address public owner;
uint public totalHospitals;
uint public totalpatient;
uint public totoalBCM;
address public Manager;
uint public totalRecord;
address public sender;
uint public patientRequestNo;
uint public patientApproveNo;
uint public totalUser;

constructor(address _manager,address _sender,address _owner){
    owner=_owner;
    totalUser=0;
    Manager=_manager;
    totalRecord=0;
    sender=_sender;
    patientApproveNo=0;
    patientRequestNo=0;
}
function callKeccak256(string memory _str) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_str));
   }  
modifier onlyCollector(){
    require(msg.sender==owner,"you are not owner");
    _;
    }

struct detailsForRegistration{
     string name;
     uint successfulCheckup;
     uint failureCheckup;
     string expertise;
}
mapping(bytes32=>detailsForRegistration) HospitalRecords;
mapping(bytes32=>bool) validateHospital;

function addHospital(string memory str,string memory exp) public onlyCollector{
    bytes32 n=callKeccak256(str);
    bool check=validateHospital[n];
    require(!check,"sorry this hospital is already registered");
    detailsForRegistration storage details=HospitalRecords[n];
    details.name=str;
    details.successfulCheckup=0;
    details.failureCheckup=0;
    details.expertise=exp; 
    validateHospital[n]=true;
    }

struct BCM{
    address id;
    uint state;
}
mapping(address=>bool) isBCM;
mapping(uint=>mapping(address=>BCM)) BcmDetails;
function addBCM(address bcm,uint pin) public onlyCollector{
    require(!isBCM[bcm],"ID EXIT");
    BCM storage details=BcmDetails[pin][bcm];
    details.id=bcm;
    details.state=pin;
    isBCM[bcm]=true;
}
struct PatientDetails{
        string name;
        bytes4 age;
        string pincode;
        string diseaseType;
        bytes32 oldDetails;
    }

mapping(bytes32=>uint) totalReport;
mapping(bytes32=>PatientDetails) usersRecords;
mapping(bytes32=>bool) isPatient;

function addNewPatient(string memory uname,string memory adhar,bytes4 a,string memory pin,string memory diseases) public onlyCollector{
    bytes32 hashValue=callKeccak256(adhar);
    require(isPatient[hashValue],"Already registered");
    PatientDetails storage details=usersRecords[hashValue];
    details.name=uname;
    details.pincode=pin;
    details.age=a;
    details.diseaseType=diseases;
    details.oldDetails=0;
    totalReport[hashValue]=0;
    isPatient[hashValue]=true;
    totalUser+=1;
}

struct transaction{
    string id;
    string disease;
}
uint trNo;
uint executedTrNo;

uint blocksize=5;

mapping(uint=>transaction) transactionCollection;

function data_to_collecter(string memory user_id, string memory _disease) public {
    bytes32 check=callKeccak256(user_id);
    require(validateHospital[check],"you are not hospital"); 
    transactionCollection[trNo]=transaction(user_id,_disease);
    trNo++;

}

}
