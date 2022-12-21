// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Counter{
    uint public counter;

    function increase() external {
        counter++;
    }

    function decrease() external {
        counter--;
    }

    function getCount() view external returns(uint){
        return counter;
    }
}