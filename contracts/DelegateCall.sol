// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Delegate call
    - a low level function similar to call
    - when contract A delegatecall contract B
    it runs B's code inside A's context (storage, msg.sender, msg.value)
    => can upgrade contract A without changing any code inside it

    => Phải đảm bảo thứ tự khai báo biến trong contract gọi delegate và contract được gọi phải giống nhau cả về tên gọi 
    lẫn thứ tự khai báo của biến, nếu thêm mới vào trong contract được gọi, phải để nó ở dưới cùng
*/

contract B{
    uint public num;
    address public sender;
    uint public value;
    address public addr; // khai báo thêm biến mới thì phải để nó ở dưới cùng


    function setVars(uint _num) public payable{
        num = _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract B2{
    address public addr;
    uint public num;
    address public sender;
    uint public value;

    function setVars(uint _num) public payable{
        num += _num;
        sender = msg.sender;
        value = msg.value;
    }
}

contract A{
    uint public num;
    address public sender;
    uint public value;

    function setVars(address _contract, uint _num) public payable{
        // (bool success, bytes memory data) = _contract.delegatecall(
        //     abi.encodeWithSignature("setVars(uint256)", _num)
        // );
        (bool success, bytes memory data) = _contract.delegatecall(
            abi.encodeWithSelector(B.setVars.selector, _num) //viết kiểu này thì thay đổi hàm nhanh hơn
        );
    }

}