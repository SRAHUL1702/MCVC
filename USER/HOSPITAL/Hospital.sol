// SPDX-License-Identifier: GPL-3.0
pragma solidity >^0.4.24;

contract Hospital{
 modifier onlyHospital(){
    if(msg.sender!=owner) throw;
    _
 }
 struct detailsForRegistration{
     string name;
     uint successfulCheckup;
     uint failureCheckup;
     string experise;
}

}
