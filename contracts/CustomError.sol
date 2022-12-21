// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//custom error
// unauthorized dùng phí gas rẻ hơn, nếu ko dùng thì phí gas sẽ tăng dựa trên độ dài đoạn thông báo lỗi
// có thể khai báo ở ngoài contract

error Unauthorized(address caller);
contract VendinMachine{
    address payable owner = payable(msg.sender);

    function withdraw() public {
        if(msg.sender != owner){
            //23642 gas
            //revert("error");

            //23678 gas
            revert("error error error error error error error error error error error error error error error error");

            //23591 gas
            //revert Unauthorized(msg.sender);
        }
        owner.transfer(address(this).balance);
    }
}