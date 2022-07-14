// SPDX-License-Identifier: GPL-3.0
pragma solidity >^0.4.2;
import "../../HBCM/COLLECTOR/Collector.sol"
contract Hospital is Collector{

 modifier onlyHospital(string memory hospital){
    require(validateHospital[hospital],"you are not hospital");
    _; 
 }
event userEvent(string name,bytes age,string pincode,string diseaseType,string oldDetails);
function getPatientDetails(string memory hospital,string user_id) public onlyHospital(hospital){
   bytes32 id=callKeccak256(user_id);
   require(isPatient[id],"Not exit");
   PatientDetails storage details=usersRecords[user_id];
   emit userEvent(details.name,details.age,details.pincode,details.diseaseType,details.oldDetails);
}

function updatePatientDetails(string memory user_id, string memory _disease) public{
   bytes32 id=callKeccak256(user_id);
   require(isPatient[id],"patient details does not exist");
  
  // hospital is sending details of patient to collecter
  data_to_collecter(id,_disease); 
  
}
function gethashFromBCM()public onlyManager returns(bytes32) {
            int currTransactionNo=executedTrNo;
            transaction storage updatingInfo = transactionCollection[currTransactionNo];
            string memory str_id=updatingInfo.id;
            string memory str_disease=updatingInfo.disease;
            bytes32 hash1=keccak256(abi.encode(str_id, str_disease));
            return hash1;
    }

event giveResponseToTrNo(uint executedTrNo);

function mineBlock()public onlyCollector{
       if(trNo>=executedTrNo+blocksize){
      for(int i=0;i<blocksize;i++){
          emit giveResponseToTrNo(executedTrNo);
            bytes32 [10]responses;
            for(int resno=0;resno<10;resno++){
                
               responses[resno] = gethashFromBCM();
            }
            bytes32 val = consesusPBFT(responses);
            if(val==-1){

            }else{
                //data update
            }
            executedTrNo++;
      }
      trNo=trNo-blocksize;
    }
}  
}
