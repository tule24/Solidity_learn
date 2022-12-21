// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Function modifier - reuse code before and / or after function
// Basic, inputs, sandwich

contract FunctionModifier{
    bool public paused;
    uint public count;

    function setPause(bool _paused) external{
        paused = _paused;
    }

    modifier whenNotPaused(){
        require(!paused, "paused");
        _; // giống kiểu placeholder, function nào kế thừa modifier này thì phần body của function đó sẽ nằm ở đây
    } 

    function inc() external whenNotPaused{
        count += 1;
    }

    function dec() external whenNotPaused{
        count -= 1;
    }

    modifier limit(uint _x){
        require(_x < 100, "x >= 100");
        _;
    }
    function incBy(uint _x) external whenNotPaused limit(_x){
        count += _x;
    }

    modifier sandwich(){
        //code here
        count += 10;
        _;
        //more code here
        count *= 2;
    }

    function foo() external sandwich {
        count += 1;
    }

    bool locked;
    uint x = 10;
    modifier noReentrancy(){ // modifier này đảm bảo cho hàm ko bị đệ quy, hàm chỉ chạy 1 lần duy nhất
        require(!locked, "Locked");
        locked = true;
        _;
        locked = false;
    }

    function decrement(uint i) public noReentrancy{
        x -= i;
        if(i > 1){
            decrement(i-1);
        }
    }
}