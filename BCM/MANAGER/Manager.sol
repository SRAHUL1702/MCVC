pragma solidity >^0.4.24;
import "../../HBCM/COLLECTOR/Sender.sol"
import "../../HBCM/COLLECTOR/Collector.sol"
import "../CONSENSUS/consensus.sol";
contract Manager is Sender,Consensus,Collector{
    modifier onlyManager(){
        require(msg.sender==manager,"Only Manager can access");
    }
    event approvePatientEvent(String msg);
    mapping(uint=>bytes32) userRequest;
    mapping(bytes32=>bool) userStatus;
    struct patientMediacalRecord{

    }
    mapping(bytes32=>mapping(uint=>patientMediacalRecord)) record;
    mapping(bytes32=>patientMediacalRecord) forUser;
    function add patientRecord() public onlyManager{

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
    
}
