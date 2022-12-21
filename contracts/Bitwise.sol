// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract BitwiseOps{
    // x     = 1110 = 8 + 4 + 2 + 0 = 14
    // y     = 1011 = 8 + 0 + 2 + 1 = 11 
    // x & y = 1010 = 10 (1 & 1 => 1; 0 & 1 || 1 & 0 => 0; 0 & 0 => 0)
    // x | y = 1111 = 15
    // x ^ y = 0101 = 5
    //
    function and(uint x, uint y) external pure returns (uint){
        return x&y;
    }
    function or(uint x, uint y) external pure returns (uint){
        return x|y;
    }
    function xor(uint x, uint y) external pure returns (uint){
        return x^y;
    }
    function not(uint8 x) external pure returns (uint8){
        // x = 00001100 = 0 + 0 + 0 + 0 + 8 + 4 + 0 + 0 = 12
        //~x = 11110011 = 128 + 64 + 32 + 16 + 0 + 0 + 2 + 1 = 243
        return ~x;
    }
    function shiftLeft(uint x, uint bits) external pure returns (uint){
        // 1 << 0 = 0001 => 0001 = 1
        // 1 << 1 = 0001 => 0010 = 2
        // 1 << 2 = 0001 => 0100 = 4
        // 1 << 3 = 0001 => 1000 = 8
        // 3 << 2 = 0011 => 1100 = 12
        return x << bits;
    }
    function shiftRight(uint x, uint bits) external pure returns (uint){
        // 8 >> 0 = 1000 => 1000 = 8
        // 8 >> 1 = 1000 => 0100 = 4
        // 8 >> 2 = 1000 => 0010 = 2
        // 8 >> 3 = 1000 => 0001 = 1
        // 8 >> 4 = 1000 => 0000 = 0
        return x >> bits;
    }

    // Get last n bits from x
    // Example
    //      x = 1101, n = 3
    // output = 0101
    function getLastNBits(uint x, uint n) external pure returns (uint){
        // Example, last 3 bits
        // x        = 1101 = 13
        // mask     = 0111 = 7
        // x & mask = 0101 = 5

        // 1 --> 1000 - 1 => 0111 => phép trừ nhị phân ???
        uint mask = (1 << n) - 1;
        return x & mask;
    }

    function getLastNBitsUsingMod(uint x, uint n) external pure returns(uint){
        return x % (2**n); // 2**n == 1 << n
    }
}