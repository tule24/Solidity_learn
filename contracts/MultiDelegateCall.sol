// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract MultiDelegatecall{
    error DelegatecallFailed();
    function multiDelegatecall(bytes[] calldata data) external payable returns(bytes[] memory results){
        results = new bytes[](data.length);
        for(uint i; i < data.length; i++){
            (bool success, bytes memory res) = address(this).delegatecall(data[i]);
            if(!success){
                revert DelegatecallFailed();
            }
            results[i] = res;
        }
    }
}

contract TestMultiDelegatecall is MultiDelegatecall{
    event Log(address caller, string func, uint i);
    function func1(uint x, uint y) public {
        emit Log(msg.sender, "func1", x + y);
    }
    function func2() public returns (uint){
        emit Log(msg.sender, "func2", 2);
        return 111;
    }

    mapping(address => uint) public balanceOf;

    //WARNING: unsafe code when used in combination with multi-delegatcall
    // user can mint multiple times fo the price of msg.value
    // tức là mình gọi 3 lần call mint func, mình chỉ cần gửi đi 1 ETH, nhưng do multiple call, số dư khi call xong là 3 ETH
    //=> nghĩa là mình chỉ tốn 1 ETH gọi hàm nhưng mình nhận được 3 ETH trong balance

    function mint() external payable{
        balanceOf[msg.sender] += msg.value;
    }
}

contract Helper{
    function getFunc1Data(uint x, uint y) external pure returns (bytes memory){
        return abi.encodeWithSelector(TestMultiDelegatecall.func1.selector, x, y);
    }
    function getFunc2Data() external pure returns (bytes memory){
        return abi.encodeWithSelector(TestMultiDelegatecall.func2.selector);
    }
    function getMintData() external pure returns (bytes memory){
        return abi.encodeWithSelector(TestMultiDelegatecall.mint.selector);
    }
}