pragma solidity >^0.4.24;
import "../COLLECTOR/Collector.sol"
contract Sender is Collector{
    struct patientRecord{
        bytes32 oldRecord;
        bytes32 newRecord;
        bytes32 id;
    }
   Mapping(bytes32=>record) patientRecord;

}
