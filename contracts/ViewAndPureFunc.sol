// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// viewFunc & pureFunc đều chỉ dùng để đọc dữ liệu, chúng không làm thay đổi giá trị của state variables
// view thì có thể đọc được các state variable (các biến bên ngoài hàm), có thể gọi các hàm pure hoặc view trong func
// pure thì không nó chỉ đọc dữ liệu đầu vào và các biến local thôi , chỉ có thể gọi các hàm pure trong func

contract ViewAndPureFunctions {
    uint public num = 5;

    // function viewFunc() external view returns (uint){
    //     num += 5;
    //     return num;
    // }
    function abc() view public {
        
    }
    function pureFunc() external pure returns (uint){
        abc();
        return 1;
    }

    function addToNum(uint x) external view returns (uint){
        abc();
        return num + x;
    }

    function add(uint x, uint y) external pure returns (uint){
        return x + y;
    }
}