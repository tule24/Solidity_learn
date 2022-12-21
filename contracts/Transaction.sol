// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* 3 ways to send ether from a contract to another contract
    - transfer (forwards 2300 gas, throws error)
    - send (forwards 2300 gas, return bool)
    - call (recommended way after 2019 Dec) (forwards all gas or set gas, return bool and data)
*/

contract SendEther{
    function sendViaTransfer(address payable _to) public payable{
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable{
        bool sent = _to.send(msg.value);
        require(sent, "Failed to send Ether");
    }

    function sendViaCall(address payable _to) public payable{
        (bool sent, bytes memory data) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

contract ReceiveEther{
    receive() external payable{}
    function getBalance() public view returns(uint){
        return address(this).balance;
    }
}