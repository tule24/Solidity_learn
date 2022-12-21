// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Multiple Inheritance and Constructors
    - Calling parent constructors
    - Order of constructor initializations
    - Shadowing inherited state variables
*/
contract A {
    string public text;
    constructor (string memory _text) public {
        text = _text;
    }
}
contract X {
    string public name;
    constructor (string memory _name) public {
        name = _name;
    }
}

contract Y is X("Fixed Input"), Y("Another Input"){

}

contract Z is X,A{
    constructor("Another way to hard code input") public {

    }
}

