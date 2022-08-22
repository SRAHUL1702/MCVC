// SPDX-License-Identifier: MIT
pragma solidity >0.4.0;
contract Collector{
address public owner;
uint public totalHospitals;
uint public totalpatient;
uint public totalBCM;
address public Manager;
address public sender;
uint public patientRequestNo;
uint public patientApproveNo;
uint public totalUser;
uint trs;
uint trt;
uint tsm;
uint tem;
uint bcmIdx;
uint mine_idx;
constructor(address _manager,address _sender,address collector){
    owner=collector;
    mine_idx=0;
    totalUser=0;
    Manager=_manager;
    sender=_sender;
    patientApproveNo=0;
    patientRequestNo=0;
    trs=0;
    trt=0;
    tsm=0;
    tem=0;
    totalBCM=0;
    bcmIdx=0;
}

function callKeccak256(string memory _str) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_str));
   }  
modifier onlyCollector(){
    require(msg.sender==owner,"you are not collector");
    _;
    }
modifier onlySender(){
    require(msg.sender==sender,"you are not sender");
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
    totalBCM++;
}
struct PatientDetails{
        string name;
        uint age;
        string pincode;
        string diseaseType;
        bytes32 oldDetails;
    }

mapping(bytes32=>uint) totalReport;
mapping(bytes32=>PatientDetails) usersRecords;
mapping(bytes32=>bool) isPatient;

function addNewPatient(string memory uname,string memory adhar,uint a,string memory pin,string memory diseases) public onlyCollector{
    bytes32 hashValue=callKeccak256(adhar);
    require(!isPatient[hashValue],"Already registered");
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

mapping(uint =>transaction) forMine;
function data_for_mining() public onlySender {
    require((trt-trs>=5 && tem==tsm && tem==0),"Not yet");
        uint s=trs;
        uint e=trt;
        for(uint i=s;i<e;i++){
            transaction storage d=transactionCollection[i];
            transaction memory d1=forMine[i];
            d1.report=d.report;
            d1.id=d.id;
            tem++;
        }
        trt=0;
        trs=0;
}


/**Manager**/

modifier onlyManager(){
        require(isBCM[msg.sender],"Only Manager can access");
        _;
} 
    struct minerData{
        address miner;
        bytes32 data;
    }
    mapping(address=>bool) checkMiner;
    mapping(uint=>minerData) res;
    mapping(uint=>bytes32) mineData;
    function Mine() public onlyManager {
        string memory s="";
        for(uint i=tsm;i<tem;i++){
            transaction storage d1=forMine[i];
            s=string(abi.encodePacked(s,d1.report));
        }
        checkMiner[msg.sender]=true;
        bytes32 hash_v=callKeccak256(s);
        minerData memory d=res[bcmIdx];
        d.miner=msg.sender;
        d.data=hash_v;
        bcmIdx++;
        if(bcmIdx==totalBCM){
            bytes32[] memory arr=new bytes32[](bcmIdx);
            for(uint i=0;i<bcmIdx;i++){
                minerData storage d1=res[i];
                arr[i]=d1.data;
                 checkMiner[d1.miner]=false;
            }
            bytes32 res_verify=consesusPBFT(arr);
            mineData[mine_idx]=res_verify;
        }
    } 

    /**Consensus**/
    function consesusPBFT(bytes32[] memory arr) public onlyManager view returns(bytes32){
     bytes32 value1=0x0000000000000000000000000000000000000000000000000000000000000000;
     bytes32 value2=0x0000000000000000000000000000000000000000000000000000000000000000;
     uint c1=0;
     uint c2=0;
     for(uint i=0;i<arr.length;i++){
         if(value1==arr[i]){
             c1++;
         }
         else if(value2==arr[i]){
             c2++;
         }
         else if(c1==0){
             value1=arr[i];
             c1++;
         }
         else if(c2==0){
             value2=arr[i];
             c2++;
         }
         else{
             c1--;
             c2--;
         }
     }

     c1=0;
     c2=0;

     for(uint i=0;i<arr.length;i++){
            if(arr[i]==value1)
                c1++;
            else if(arr[i]==value2)
                c2++;
     }

     if(c1>arr.length/3 && value1!=0x0000000000000000000000000000000000000000000000000000000000000000)
            return value1;
     if(c2>arr.length/3 && value2!=0x0000000000000000000000000000000000000000000000000000000000000000)
        return value2;

        return 0x0000000000000000000000000000000000000000000000000000000000000000;
    }

    /**Consensus**/

    event approvePatientEvent(string msg);
    mapping(uint=>bytes32) userRequest;
    mapping(bytes32=>bool) userStatus;
    struct patientMedicalRecord{
            string disease;
            string report;
            uint age;
    }
      
    
    /*Hospital*/

    modifier onlyHospital(bytes32 hospital){
    require(validateHospital[hospital],"you are not hospital");
    _; 
    }

    event userEvent(uint age,string diseaseType,string oldDetails);
    function getPatientDetails(string memory hospital,string memory user_id) public onlyHospital(callKeccak256(hospital)){
        bytes32 id=callKeccak256(user_id);
        require(isPatient[id],"Not exit");
        PatientDetails storage details=usersRecords[id];
        emit userEvent(details.age,details.pincode,details.diseaseType);
    }
    struct transaction{
    bytes32 id;
    string report;
    }
    mapping(bytes32=>mapping(uint=>string)) record;
    mapping(uint=>transaction) transactionCollection;
    function updatePatientDetails(string memory hospital,string memory user_id, string memory _report) public onlyHospital(callKeccak256(hospital)){
        bytes32 id=callKeccak256(user_id);
        require(isPatient[id],"patient details does not exist");
        uint totalBlock=totalReport[id];
        record[id][totalBlock]=_report;
        transaction memory details=transactionCollection[trt];
        details.id=id;
        details.report=_report;
        trt++;
    }
    
}
