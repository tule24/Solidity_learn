// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract IterableMapping{
    mapping(address => uint) public balances;
    mapping(address => bool) public inserted;
    address[] public keys;
    function set(address _key, uint _val) external {
        balances[_key] = _val;
        if( !inserted[_key]){
            inserted[_key] = true;
            keys.push(_key);
        }
    }

    function getSize() external view returns (uint){
        return keys.length;
    }

    function getBalances(uint _index) external view returns (uint){
        require(_index < keys.length, "Index must be less than keys.length");
        return balances[keys[_index]];
    }
}