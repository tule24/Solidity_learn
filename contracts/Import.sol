// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Import
Examples
    - local files
    - github (only in Remix) (different branches)

Folder
browser
|--Import.sol
|--HelloWorld.sol
*/

/* Library
    - No storage, no ether
    - Helps you keep your code DRY (Don't Repeat Yourself)
    - Add functionality types
    - Can save gas
Embedded or linked
    - Embedded (library has only internal functions)
    - Must be deployed and then linked (library has public or external functions)
Examples 
    - Safe math (prevent uint overflow)
    - Deleting element from array without gaps
*/
import "./HelloWorld.sol";
contract Import{}

library SafeMath {
    function add(uint x, uint y) internal pure returns (uint) {
        uint z;
        unchecked{z = x + y;}
        require(z >= x, "uint overflow");
        return z;
    }
}
library Remove{
    function remove(uint[] storage arr, uint index) public{
        arr[index] = arr[arr.length - 1];
        arr.pop();
    }
}
contract TestSafeMath{
    using SafeMath for uint;
    uint public MAX_INT = type(uint).max;
    // using A for B
    // attach functions from library A to type B

    //uint x = 456 => x.add(123) cách sử dụng khác

    function testAdd(uint x, uint y) public pure returns (uint){
        return x.add(y);
    }
}

contract TestRemovre{
    using Remove for uint[]; // áp dụng library cho kiểu dữ liệu này, chỉ cần sử dụng các biến khai báo kiểu dữ liệu này thì đều . ra được func của library
    uint[] public arr = [1,2,3,4,5];

    function testRemove(uint _index) public {
        require(_index < arr.length, "Index must be less than arr.length");
        arr.remove(_index);
        assert(arr.length == 4);
    }

}