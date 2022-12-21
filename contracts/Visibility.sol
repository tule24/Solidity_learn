// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* private, interval, public, external
    - private: only inside contract
    - interval: only inside contract and child contracts
    - public: inside and outside contract
    - external: only from outside contract
*/
contract  Base{
    function privateFunc() private pure returns (string memory) {
        return "private function called";
    }

    function testPrivateFunc() public pure returns (string memory){
        return privateFunc();
    }

    function internalFunc() internal pure returns (string memory){
        return "internal function called";
    }

    function testInternalFunc() virtual public pure returns(string memory){
        return internalFunc();
    }

    function publicFunc() virtual public pure returns(string memory){
        return "public function called";
    }

    function externalFunc() virtual external pure returns (string memory){
        return "external function called";
    }

    // function testEXternalFunc() virtual public pure returns(string memory){
    //     return externalFunc();
    // }

    string private privateVar = "my private var";
    string internal internalVar = "my internal var";
    string public publicVar = "my public var";
    //string external externalVar = "my external var";

}

contract Child is Base{
    // function testPrivateFunc() public pure returns(string memory){
    //     return privateFunc();
    // }

    function testInternalFunc() override public pure returns(string memory){
        return internalFunc();
    }
}