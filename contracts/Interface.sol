// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// How to interact with deployed contract?
// Interface
// Uniswap example

interface ICounter{
    //function getCount() view external returns(uint);
    function counter() view external returns(uint);
    function increase() external;
}

contract MyContract{
    uint public count;
    function incrementCounter(address _counter) external{
        ICounter(_counter).increase();
        count = ICounter(_counter).counter();
    }

    // function getCount(address _counter) external view returns (uint){
    //     ICounter(_counter).counter();
    // }
}