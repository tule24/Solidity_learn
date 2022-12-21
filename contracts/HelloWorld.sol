// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Smart contract should be
    - Simple
    - Reliable
    - Predictable
*/
contract HelloWorld{
    string public myString = "Hello World";
    string[] public arr = ['a', 'b', 'c'];
    function create(string calldata _text) pure public returns(string memory){
        string memory text = _text;
        return text;
    }
}
