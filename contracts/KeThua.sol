// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract A{
    function foo() public pure virtual returns (string memory){
        return "A";
    }

    function bar() public pure virtual returns (string memory){
        return "A";
    }

    function zoo() public pure returns (string memory){
        return "A";
    }
}

contract B is A{
    function foo() public pure override returns (string memory){
        return "B";
    }
    function bar() public pure virtual override returns (string memory){
        return "B";
    }
}

contract C is B{
    function bar() public pure override returns (string memory){
        return "C";
    }
}

// Multiple inheritance
contract X{
    function foo() public pure virtual returns (string memory){
        return "X";
    }

    function bar() public pure virtual returns (string memory){
        return "X";
    }

    function x() public pure returns (string memory){
        return "X";
    }
}

contract Y is X{
    function foo() public pure virtual override returns (string memory){
        return "Y";
    }
    function bar() public pure virtual override returns (string memory){
        return "Y";
    }
    function y() public pure returns (string memory){
        return "Y";
    }
}

contract Z is X, Y{ // kế thừa theo thứ tự từ base contract đến child contract
    function foo() public pure override(X,Y) returns (string memory){
        return "Z";
    }
    function bar() public pure override(Y,X) returns (string memory){
        return "Z";
    }
}

// Constructor
// 2 ways to call parent constructors
// Order of initialization

contract S{
    string public name;
    constructor(string memory _name){
        name = _name;
    }
}

contract T {
    string public text;
    constructor(string memory _text){
        text = _text;
    }
}

contract U is S("s"), T("t"){

}

contract V is S, T{
    constructor(string memory _name, string memory _text) S(_name) T(_text){}
}

contract W is S("S"), T{
    constructor(string memory _text) T(_text){}
}

//Order of execution
//  1. S
//  2. T
//  3. V0
contract V0 is S, T{
    constructor(string memory _name, string memory _text) S(_name) T(_text){}
}

//Order of execution
//  1. S
//  2. T
//  3. V1
contract V1 is S, T{
    constructor(string memory _name, string memory _text) T(_text) S(_name){}
}

//Order of execution
//  1. T
//  2. S
//  3. V1
contract V2 is T, S{
    constructor(string memory _name, string memory _text) T(_text) S(_name){}
}

//Order of execution
//  1. T
//  2. S
//  3. V3
contract V3 is T, S{
    constructor(string memory _name, string memory _text) S(_name) T(_text){}
}

// Calling parent functions
// - direct
// - super

contract E {
    event Log(string message);
    function foo() public virtual{
        emit Log("E.foo");
    }
    function bar() public virtual{
        emit Log("E.bar");
    }
}

contract F is E{
    function foo() public virtual override{
        emit Log("F.foo");
        E.foo();
    }

    function bar() public virtual override{
        emit Log("F.bar");
        super.bar();
    }
}

contract G is E{
    function foo() public virtual override{
        emit Log("G.foo");
        E.foo();
    }

    function bar() public virtual override{
        emit Log("G.bar");
        super.bar();
    }
}

contract H is F,G{
    function foo() public override(F,G){
        F.foo(); // gọi trực tiếp từ parent contract được gọi
    }

    function bar() public override(F,G){
        super.bar(); // gọi tất cả cha mẹ mà nó kế thừa
    }
}