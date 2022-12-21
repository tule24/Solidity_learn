// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Data types: có 2 kiểu tham trị (values) và tham chiếu (references)
// Values: bool, int, uint, address / address payable(transfer, send), contract, string, fucntion, ...
// Reference: structs, arrays, mapping, strings
contract ValueTypes{
    bool public b = true;
    uint public u = 123; // uint = uint256 0 to 2**256 - 1
                         //        uint8 0 to 2**8 - 1
                         //        uint16 0 to 2**16 - 1
    int public i = -123; // int = int256 -2**255 to 2**255 - 1
                         //       int128 -2**127 to 2**127 - 1
    int public minInt = type(int).min;
    int public maxInt = type(int).max;
    address public addr = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;
    bytes32 public b32 = 0x111122223333444455556666777788889999AAAABBBBCCCCDDDDEEEEFFFFCCCC;
    address public abc;
}
