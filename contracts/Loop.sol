// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Loop{
    uint public count;
    address[] public arr;
    uint public leng = arr.length;
    function loop(uint n) public{
        for(uint i = 0; i < n; i++){
            count++;
        }
        uint a = 5;
        while (a < 10) {
            a++;
        }
    }
}