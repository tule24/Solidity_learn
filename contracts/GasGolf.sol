// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* GasGolf
    - Start - 50992 gas
    - use calldata - 49163 gas
    - load state variables to memory - 48952 gas
    - short circuit - 48634 gas
    - loop increments - 48244 gas
    - cache array length - 48209 gas
    - load array elements to memory - 48047 gas
*/
contract GasGolf{
    uint public total;
    //[1, 2, 3, 4, 5, 100]

    function sumIfEvenAndLessThan99(uint[] calldata /*memory*/ nums) external{ 
        uint _total = total;
        uint len = nums.length;
        for (uint i = 0; i < len; ++i/*i += 1*/){
            // bool isEven = nums[i] % 2 == 0;
            // bool isLessThan99 = nums[i] < 99;
            uint num = nums[i];
            if(num % 2 == 0 && num < 99){
                _total += num;
            }
        }
        total = _total;
    }
}