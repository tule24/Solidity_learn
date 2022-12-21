// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Mục đích của timelock là trì hoãn thực hiện một hợp đồng, khi hết thời gian delay thì hợp đồng mới được thực hiện
contract TimeLock{
    error NotOwnerError();
    error AlreadyQueuedError(bytes32 txId);
    error TimestampNotInrangeError(uint blockTimestamp, uint timestamp);
    error NotQueuedError(bytes32 txId);
    error TimestampNotPassedError(uint blockTimestamp, uint timestamp);
    error TimestampExpiredError(uint blockTimestamp, uint expiresAt);
    error TxFailedError();

    event Queue( bytes32 indexed _txId, address indexed _target, uint _value, string _func, bytes _data, uint _timestamp );
    event Execute( bytes32 indexed _txId, address indexed _target, uint _value, string _func, bytes _data, uint _timestamp );
    event Cancel(bytes32 indexed txId);

    uint public constant MIN_DELAY = 10;
    uint public constant MAX_DELAY = 1000;
    uint public constant GRACE_PERIOD = 1000;
    
    address public owner;
    mapping(bytes32 => bool) public queued; 

    constructor(){
        owner = msg.sender;
    }
    receive() external payable{}
    modifier onlyOwner(){
        if(msg.sender != owner){
            revert NotOwnerError();
        }
        _;
    }

    function getTxId (
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) public pure returns(bytes32 txId){
        return keccak256(abi.encode(_target, _value, _func, _data, _timestamp));
    }

    function queue(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external onlyOwner{
        // create tx id
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
        
        // check tx id unique
        if(queued[txId]){
            revert AlreadyQueuedError(txId);
        }
        
        // check timestamp
        // ---|-------------|----------------|--------
        //  block     block + min      block + max
        if(_timestamp < block.timestamp + MIN_DELAY || _timestamp > block.timestamp + MAX_DELAY){
            revert TimestampNotInrangeError(block.timestamp, _timestamp);
        }

        // queue tx
        queued[txId] = true;
        
        emit Queue(txId,_target, _value, _func, _data, _timestamp);
    }

    function checkQueued(address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp) external view returns (bool)
        {
            bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);
            return queued[txId];
        }

    function execute(
        address _target,
        uint _value,
        string calldata _func,
        bytes calldata _data,
        uint _timestamp
    ) external payable onlyOwner returns(bytes memory){
        bytes32 txId = getTxId(_target, _value, _func, _data, _timestamp);

        // check tx is queued
        if(!queued[txId]){
            revert NotQueuedError(txId);
        }

        // check timestamp
        if(block.timestamp < _timestamp){
            revert TimestampNotPassedError(block.timestamp, _timestamp);
        }
        // ---|---------------------|-----------------
        //  timestamp     timestamp + grace period
        if(block.timestamp > _timestamp + GRACE_PERIOD){
            revert TimestampExpiredError(block.timestamp, _timestamp + GRACE_PERIOD);
        }

        // delete tx from queue
        queued[txId] = false;

        // execute the tx
        bytes memory data;
        if(bytes(_func).length > 0){
            data = abi.encodePacked(
                bytes4(keccak256(bytes(_func))), _data
            );
        } else {
            data = _data;
        }

        (bool success, bytes memory res) = _target.call{value: _value}(data);
        if(!success){
            revert TxFailedError();
        }

        emit Execute(txId,_target, _value, _func, _data, _timestamp);
        return res;
    }

    function cancel(bytes32 _txId) external onlyOwner{
        if(!queued[_txId]){
            revert NotQueuedError(_txId);
        }
        queued[_txId] = false;
        emit Cancel(_txId);
    }
}

contract TestTimeLock{
    address public timeLock;
    constructor(address _timeLock){
        timeLock = _timeLock;
    }

    function getTimestamp() external view returns(uint) {
        return block.timestamp;
    }
    function test() view external{
        require(msg.sender == timeLock);
        /* more code here such as
            - upgrade contract
            - transfer funds
            - switch price oracle
        */
    }
}