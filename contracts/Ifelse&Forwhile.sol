// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract IfElse {
    function example(uint _x) external pure returns (uint){
        if(_x < 10) {
            return 1;
        } else if(_x < 20){
            return 2;
        } return 3;
    }

    function ternary(uint _x) external pure returns (uint){
        return _x < 10 ? 1 : 2;
    }
}

// Lưu ý khi dùng vòng lặp trong solidity, số lần loop càng lớn thì gas fee càng cao
contract ForWhile {
    function loops() external pure{
        for(uint i = 0; i < 10; i++){
            // code
            if(i == 3){
                continue;
            }

            if(i == 5){
                break;
            }
        }

        uint j = 0;
        while (j < 10){
            //code
            j++;
        }
    }

    function sum(uint _n) external pure returns (uint){
        uint s = 0;
        for(uint i = 0; i <= _n; i++){
            s += i;
        }
        return s;
    }

    // n = 10 => 25984 gas
    // n = 11 => 26362 gas
    // n = 20 => 29764 gas
    // n = 50 => 41104 gas
}