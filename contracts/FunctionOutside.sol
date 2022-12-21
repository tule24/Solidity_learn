// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// func có thể tạo ở bên ngoài contract và import ở các contract khác để tái sử dụng lại nó
// tuy nhiên nó cũng mặt hạn chế là ko thể sử dụng các biến ở trong contract được, ko sử dụng this được
function helper(uint x) view returns (uint){
    return x*2;
}

contract TestHelper {
    uint foo;
    function test() external view returns (uint) {
        return helper(123);
    }
}