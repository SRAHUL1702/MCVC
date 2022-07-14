pragma solidity >^0.4.24;
import "../../HBCM/COLLECTOR/Sender.sol"
import "../../HBCM/COLLECTOR/Collector.sol"
import "../CONSENSUS/consensus.sol";
contract Manager is Consensus,Collector{
    modifier onlyManager(){
        require(isBCM[msg.sender],"Only Manager can access");
        _;
    }
    event approvePatientEvent(string msg);
    mapping(uint=>bytes32) userRequest;
    mapping(bytes32=>bool) userStatus;
    struct patientMedicalRecord{
            string disease;
            string report;
            bytes4 age;
    }
   mapping(bytes32=>mapping(uint=>patientMedicalRecord)) record;
   mapping(bytes32=>patientMedicalRecord) forUser;

    function addatientRecord(string memory adhar,string memory _disease,string memory _report,bytes4 _age) public onlyManager{
            bytes32 id=callKeccak256(adhar);
            patientMedicalRecord storage detail=record[id][totalReport[id]+1];
            detail.disease=_disease;
            detail.report=_report;
            detail.age=_age;
    }

    function approvaPatientStatus() public onlyManager{
        if(patientApproveNo==patientRequestNo){
            patientApproveNo=0;
            patientRequestNo=0;
            emit approvaPatientStatus("All user request approved");
        }
        else{
            bytes32 id=userRequest[patientRequestNo];
            totalReport[id];
            require(totalReport[id]>0,"Not Checked yet");
            mapping(uint=>patientMediacalRecord) res=record[id];
            patientMediacalRecord storage r=res[totalReport[id]-1];
            forUser[id]=r;
            patientApproveNo++;
            emit approvaPatientStatus("successFul Approve");
        }
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