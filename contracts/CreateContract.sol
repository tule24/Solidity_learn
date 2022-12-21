// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Contract that creates other contract
    How is it useful?
        - pass fixed inputs to a new contract
        - manage many contracts from a single contract
    Examples
        - create a new contract
        - send ether and create a new contract
*/

contract Car{
    string public model;
    address public owner;
    uint public balance = address(this).balance;
    constructor(string memory _model, address _owner) payable{
        model = _model;
        owner = _owner;
    }
}

contract CarFactory{
    Car[] public cars;
    function create(string memory _model) public{
        Car car = new Car(_model, address(this));
        cars.push(car);
        // contract.func{value: 1 ether}(x,y,z)
        // (new Car){value: 1 ether}(x,y,z)
    }

    function createAndSendEther(address _owner, string memory _model) public payable{
        Car car = (new Car){value: msg.value}(_model, _owner);
        cars.push(car);
    }
}
