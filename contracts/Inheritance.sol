// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/*
    - Inheritance
        + inherit functions
        + override functions
    - Passing parameters to parent constructor
        + fixed parameters
        + variable parameters
*/

contract A{
    function getContractName() public pure virtual returns (string memory) { // virtual chỉ func có thể bị ghi đè
        return "Contract A";
    }
}

contract B is A{ // dùng từ khóa is để kế thừa contract
    function getContractName() public pure override returns (string memory) {// override chỉ func ghi đè
        return "Contract B";
    }
}

abstract contract C {
    string public name;
    constructor(string memory _name) {
        name = _name;
    }
}

contract D is C("ABC"){ // dùng từ khóa is để kế thừa contract
    constructor(){}
}

contract X{
    event Log(string message);
    function foo() virtual public {
        emit Log("A.foo was called");
    }
    function bar() virtual public {
        emit Log("A.bar was called");
    }
    // function foo() public pure returns (string memory) {
    //     return "Contract X";
    // }
}
contract Y is X{
    // function bar() public pure returns (string memory) {
    //     return "Contract Y";
    // }
    function foo() virtual override public {
        emit Log("B.foo was called");
        X.foo();
    }

    function bar() virtual override public {
        emit Log("B.bar was called");
        super.bar();
    }
}
contract Z is X{ // Khi kế thừa nếu có 2 func trùng tên nhau thì nó sẽ kế thừa cái func của contract theo thứ tự phải sang trái
    function foo() virtual override public {
        emit Log("C.foo was called");
        X.foo();
    }
}
// contract W is Y,Z{
//     function foo() override(Y,Z) public{}
// }