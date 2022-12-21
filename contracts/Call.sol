// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Call - low level method available on address type
    examples:
        - call existing function
        - call non-existing function (triggers the fallback function)
*/
contract Caller{
    event Response(bool success, bytes data);
    function testCallFoo(address payable _addr) public payable{
        (bool success, bytes memory data) = _addr.call{value: msg.value, gas: 5000}(
            abi.encodeWithSignature("foo(string,uint256)", "call foo", 123)
        );
        emit Response(success, data);
        // data: 0x000000000000000000000000000000000000000000000000000000000000007c = 124 => return mà hàm foo trả về
    }
    function testCallDoesNotExist(address _addr) public {
        (bool success, bytes memory data) = _addr.call(
            abi.encodeWithSignature("doesNotExist()")
        );
        emit Response(success, data);
    }
}

contract Receiver{
    event Received(address caller, uint amount, string message);
    event noExist(address caller, string message);
    receive() external payable{
        emit Received(msg.sender, msg.value, "Fallback was called");
    }
    fallback() external {
        emit noExist(msg.sender, "Fallback was called");
    }
    function foo(string memory _message, uint _x) public payable returns (uint) {
        emit Received(msg.sender, msg.value, _message);
        return _x+1;
    }
}