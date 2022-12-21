// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

//safe math
// an toàn toán học, trong 0.8, nếu xảy ra hiện tượng tràn số sẽ trả về error
// muốn tắt chức năng này ta dùng unchecked, tràn dưới trả về số lớn nhất và ngược lại
contract SafeMath{
    function testUnderflow() public pure returns (uint){
        uint x = 0;
        x--;
        return x;
    }

    function testUncheckedUnderflow() public pure returns (uint){
        uint x = 0;
        unchecked{x-- ;}
        return x;
    }
}