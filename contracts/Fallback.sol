// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Hàm dự phòng, hàm này sẽ được gọi trong 2 trường hợp: 
//  - Gọi một hàm ko tồn tại trong contract
//  - Khi gửi Ether đến hợp đồng này bằng transfer, send, call
contract Fallback{
    event Log(uint gas);

    receive() external payable{
        // send / transfer (forwards 2300 gas to this fallback function)
        // call (forward all of the gas)
        emit Log(gasleft());
    }

    function getBalance() public view returns (uint){
        return address(this).balance;
    }
}

contract SendToFallback{
    function transferFallback(address payable _to) public payable{
        _to.transfer(msg.value);
    }

    function callFallback(address payable _to) public payable{
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send Ether");
    }
}

/* fallback() or receive()?
        Ether is sent to contract
                    |
            is msg.data empty?
                    /\
                yes    no
                /       \
    receive() exist?    fallback()
                /\
             yes  no
             /      \
        receive()   fallback()           
*/

contract Fallback1{
    event Log(string func, address sender, uint value, bytes data);
    fallback() external payable{
        emit Log("Fallback", msg.sender, msg.value, msg.data);
    }
    receive() external payable{
        emit Log("Receive", msg.sender, msg.value, "");
    }
}