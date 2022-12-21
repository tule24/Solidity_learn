// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Immutable{
    //address public immutable owner = msg.sender; //43585 gas
    address public owner; //	45718 gas

    constructor(){
        owner = msg.sender;
    }
    uint public x;
    function foo() external{
        require(msg.sender == owner);
        x += 1;
    }

    // more code here
}