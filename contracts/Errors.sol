// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Có 3 cách trả lỗi: require, revert, assert
// require: chủ yếu được sử dụng validation input và access control => ko sử dụng hết gas mà mình gửi
// revert: chủ yếu được sử dụng khi lồng nhiều if/else
// assert: dùng để kiểm tra một điều kiện luôn luôn đúng, nếu nó sai thì đồng nghĩa contract đang có lỗi xảy ra => Có thể sử dụng hết gas mà mình gửi cùng với transaction của mình 
// - Khi lỗi được trả ra, gas fee sẽ được hoàn lại và return state đã update: gas refund, state updates are reverted
// - Sử dụng custom error => save gas => lỗi càng dài gas càng nhiều  => dùng custom error để save gas
contract Errors {
    function testRequire(uint _i) public pure{
        require(_i <= 10, "i > 10");
        //code
    }

    function testRevert(uint _i) public pure{
        if(_i > 10){
            revert("i > 10");
        }
        //code
    }

    uint public num = 123;
    function testAssert() public view{
        assert(num == 123);
    }
    function foo(uint _i) public {
        num++; // => bắn ra lỗi
        require(_i < 10);
    }

    error MyError(address caller, uint i);
    function testCustomError(uint _i) public view{
        if(_i > 10){
            revert MyError(msg.sender, _i);
        }
        //code
    }
}

contract Account{
    uint public balance;
    uint public constant MAX_UINT = 2**256 - 1;
    function deposit(uint _amount) public {
        uint oldBalance = balance;
        uint newBalance = balance + _amount;
        require(newBalance >= oldBalance, "Overflow");

        balance = newBalance;
        assert(balance >= oldBalance);
    }

    function withdraw(uint _amount) public {
        require(_amount <= balance, "Overflow");
        uint oldBalance = balance;
        balance -= _amount;
        assert(balance <= oldBalance);
    }
}