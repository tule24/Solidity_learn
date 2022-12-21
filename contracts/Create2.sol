// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
contract D {
    uint public x;
    constructor(uint a) {
        x = a;
    }
}

contract DeployWithCreate2{
    address public owner;

    constructor(address _owner){
        owner = _owner;
    }
}

contract Create2Factory{
    event Deploy(address addr);
    function deploy(uint _salt) external{
        DeployWithCreate2 _contract = new DeployWithCreate2{
            salt: bytes32(_salt) // salt là số ngẫu nhiên 
        }(msg.sender);
        emit Deploy(address(_contract));
    }

    function getAddress(bytes memory bytecode, uint _salt) public view returns(address){
        bytes32 hash = keccak256(
            abi.encodePacked(bytes1(0xff), address(this), _salt, keccak256(bytecode))
        );
    return address(uint160(uint(hash)));
    }

    function getBytecode(address _owner) public pure returns(bytes memory){
        bytes memory bytecode = type(DeployWithCreate2).creationCode;
        return abi.encodePacked(bytecode, abi.encode(_owner));
    }
    //0xDbB6B6c7cca38aAbBA21419daaB57Ea0Cb32B290
    //0xDbB6B6c7cca38aAbBA21419daaB57Ea0Cb32B290
}



contract Create2 {
    function getBytes32(uint salt) external pure returns (bytes32){
        return bytes32(salt);
    }
 
    function getAddress(bytes32 salt, uint arg) external view returns (address) {
        address addr = address(uint160(uint(keccak256(abi.encodePacked(
            bytes1(0xff),
            address(this),
            salt,
            keccak256(abi.encodePacked(
                type(D).creationCode,
                abi.encode(arg)
            ))
        )))));
        return addr;
    }

    address public deployedAddr;
    
    function createDSalted(bytes32 salt, uint arg) public {
        D d = new D{salt: salt}(arg);
        deployedAddr = address(d);
    }
}