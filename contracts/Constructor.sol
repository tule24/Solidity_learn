// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// constructor chỉ được gọi 1 lần duy nhất ngay khi contract được triển khai
// chủ yếu được dùng để khởi tạo các state variable như địa chỉ người tạo, ...
contract Constructor {
    address public owner;
    uint public x;

    constructor(uint _x){
        owner = msg.sender;
        x = _x;
    }
}