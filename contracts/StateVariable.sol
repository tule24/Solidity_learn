// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// các biến lưu trữ dữ liệu trên blockchain ta thường lưu trong contract và nằm ngoài các function
// 1024 KB / 1MB
// 640.000 gas / KB
// 10 gwei / gas
// 0.000000001 ETH/ 1 gwei
// Solidity cũng mặc định tạo 1 hàm getters cho các state variable ở trạng thái public

contract StateVariables{
    uint public myUint = 123; // => state variable
    function foo() external pure {
        uint notStateVariable = 456;
    }
}