// SPDX-License-Identifier: GPL-3.0
pragma solidity >^0.4.24;
import "../../HBCM/COLLECTOR/Collector.sol"
contract Hospital is Collector{

 modifier onlyHospital(string memory hospital){
    require(validateHospital[hospital],"you are not hospital"); 
 }
event userEvent(string name,bytes age,string pincode,string diseaseType,string oldDetails);
function getPatientDetails(string memory hospital,string user_id) public onlyHospital(hospital){
   bytes32 id=callKeccak256(user_id);
   require(isPatient[id],"Not exit");
   PatientDetails storage details=usersRecords[user_id];
   emit userEvent(details.name,details.age,details.pincode,details.diseaseType,details.oldDetails);
}
}
