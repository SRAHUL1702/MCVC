pragma solidity >^0.4.24;
contract Collector{
address owner;
uint totalHospitals;
uint totalpatient;
uint totoalBCM;
address Manager;
uint totalRecord;
address sender;
constructor(address _manager,address _sender,address _owner) public{
    owner=_owner;
    totalUser=0;
    Manager=_manager;
    totalRecord=0;
    sender=_sender;
}

function callKeccak256(string memory adhar) public pure returns(bytes32 result){
      return keccak256(name);
   }  

modifier onlyCollector(){
    if(msg.sender!=owner) throw;
    _
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
    details.name=n;
    details.successfulCheckup=0;
    details.failureCheckup=0;
    details.expertise=exp; 
    validateHospital[n]=true;
    }

struct PatientDetails{
        string name;
        bytes age;
        string pincode;
        string diseaseType;
        bytes32 oldDetails;
    }

mapping(bytes32=>PatientDetails) usersRecords;
mapping(bytes32=>bool) isPatient;
functions addNewPatient(string memory uname,string memory adhar,bytes a,string memory pin,string memory diseases,string memory olddetail) public onlyCollector{
    bytes32 hashValue=callKeccak256(adhar);
    require(isPatient[hashValue],"Already registered");
    PatientDetails storage details=usersRecords[hashValue];
    details.name=uname;
    details.pincode=pin;
    details.age=a;
    details.diseaseType=diseases;
    details.oldDetails=0;
    isPatient[hashValue]=true;
    totalUser+=1;
}

struct BCM{
    address id;
    uint state;
}
mapping(address=>bool) isBCM;
mapping(uint=>mapping(address=>BCM)) BcmDetails;
function addBCM(address bcm,uint pin) public onlyCollector{
    require(!isBCM(bcm),"ID EXIT");
    mapping(address=>BCM) temp=BcmDetails(pin);
    BCM storage details=temp(bcm);
    details.id=bcm;
    details.state=pin;
    BcmDetails[pin]=temp;
    isBCM[bcm]=true;
}
}
