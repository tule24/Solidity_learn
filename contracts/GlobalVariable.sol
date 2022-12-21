// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// global variable thường dùng để lưu trữ các thông tin như thông tin giao dịch, tài khoản
contract GlobalVariable {
    function globalVars() external view returns (address, uint, uint){
        address sender = msg.sender; // địa chỉ của người gọi hàm => global var
        uint timestamp = block.timestamp; // thời điểm hàm này được call
        uint blockNum = block.number; // lưu trữ số khối hiện tại
        return (sender, timestamp, blockNum);
    }
}