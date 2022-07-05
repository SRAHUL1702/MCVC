pragma solidity >^0.4.24;
import "../../HBCM/COLLECTOR/Sender.sol"
import "../CONSENSUS/consensus.sol";
contract Manager is Sender,Consensus{
    modifier onlyManager(){
        require(msg.sender==manager,"Only Manager can access");
    }
    
    
}
