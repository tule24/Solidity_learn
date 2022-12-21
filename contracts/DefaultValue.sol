// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Local variable & state variable khi không khai báo giá trị ban đầu cho nó thì nó sẽ có giá trị mặc định
contract DefaultValues{
    bool public b; // false
    uint public u; // 0
    int public i; // 0
    address public addr; // 0x0000000000000000000000000000000000000000 (40 số 0)
    bytes32 public b32; // 0x0000000000000000000000000000000000000000000000000000000000000000 (64 số 0)
    // mapping, structs, enum, fixed sized arrays
}