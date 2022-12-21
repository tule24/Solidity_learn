// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Calling other contracts
    Examples
        - call non payable function in another contract
        - call payable function in another contract
    => Việc gọi contract kiểu này thì có thể phát hiện được các func đang ko tồn tại trong contract được gọi khi compile
    còn nếu sử dụng call thì dù func có hoặc ko nó sẽ vẫn compile và sẽ nhảy vào fallback nếu func ko tồn tại
*/

contract Callee{
    uint public x;
    uint public value;
    function setX(uint _x) public returns (uint){
        x = _x;
        return x;
    }

    function setXAndSendEther(uint _x) public payable returns (uint, uint){
        x = _x;
        value = msg.value;
        return (x, value);
    }
}

contract Caller{
    function setX(Callee _callee, uint _x) public {
        uint x = _callee.setX(_x);
    }

    function setXFromAddress(address _addr, uint _x) public {
        Callee callee = Callee(_addr);
        uint x = callee.setX(_x);
    }

    function setXAndSendEther(Callee _callee, uint _x) public payable{
        (uint x, uint value) = _callee.setXAndSendEther{value: msg.value}(_x);
    }
}