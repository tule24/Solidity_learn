// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// state variables
// global variables
// function modifier
// function
// error handling

contract Ownable {
    address public owner;
    address public addr;
    constructor (){
        owner  = msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner");
        _;
    }

    function setOwner(address _newOwner) external onlyOwner{
        require(_newOwner != address(0), "invalid address"); // address(0) = 0x0000000000000000000000000000000000000000
        owner = _newOwner;
    }

    function onlyOwnerCanCallThisFunc() external onlyOwner{
        //code
    }

    function anyOneCanCall() external {
        //code
    }
}