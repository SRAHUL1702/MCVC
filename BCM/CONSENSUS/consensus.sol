// SPDX-License-Identifier: MIT
pragma solidity >0.4.0;
contract Consensus{
 function consesusPBFT(bytes32[] memory arr) external pure returns(bytes32){
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
}
