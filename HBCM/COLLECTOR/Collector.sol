pragma solidity >^0.4.24;
import "../../USER/HOSPITAL/Hospital.sol"
import "../../USER/HOSPITAL/Patient.sol"
contract Collector is Hospital,Patient{
address owner;
uint totalUser;
constructor() public{
    owner=msg.sender;
    totalUser=0;
}

modifier onlyCollector(){
    if(msg.sender!=owner) throw;
    _
}
mapping(string=>detailsForRegistration) HospitalRecords;
mapping(string=>bool) validateHospital;

mapping(uint=>PatientDetails) usersRecords;

function addHospital(string memory n,string memory exp) public onlyCollector{
    bool check=validateHospital[n];
    require(!check,"sorry this hospital is already register");
    detailsForRegistration storage details=HospitalRecords[n];
    details.name=n;
    details.successfulCheckup=0;
    details.failureCheckup=0;
    details.experise=exp; 
    validateHospital[n]=true;
    }

functions addUser(string memory uname,bytes a,string memory pin,string memory diseases,string memory olddetail) public onlyCollector{
    PatientDetails storage details=usersRecords[totalUser];
    details.name=uname;
    details.pincode=pin;
    details.age=a;
    details.diseaseType=diseases;
    details.oldDetails=olddetail;
    totalUser+=1;
}
}
