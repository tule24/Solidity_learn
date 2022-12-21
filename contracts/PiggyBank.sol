// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract PiggyBank{
    event Donate(address indexed sender, uint amount);
    event Destroy(string message);
    address payable public owner;
    receive() external payable{}

    constructor(){
        owner = payable(msg.sender);
    }

    modifier isOwner(){
        require(msg.sender == owner, "not authorize");
        _;
    }

    function donate() external payable{
        emit Donate(msg.sender, msg.value);
    }

    function destroy() external isOwner{
        emit Destroy("Destroy contract");
        selfdestruct(owner);
    }

    function getBalance() external view returns (uint){
        return address(this).balance;
    } 
}