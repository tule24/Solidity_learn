// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.0;

contract Transactions {
    uint transactionCount;

    event Transfered(uint indexed id, address from, address to, uint amount, string message, uint timestamp);

    struct Transfer{
        address sender;
        address receiver;
        uint amount;
        string message;
        uint timestamp;
    }

    Transfer[] transactions;

    function transfer(address receiver, uint amount, string memory message) public {
        transactionCount += 1;
        transactions.push(Transfer(msg.sender, receiver, amount, message, block.timestamp));
        emit Transfered(transactionCount, msg.sender, receiver, amount, message, block.timestamp);
    }

    function getAllTransactions() public view returns(Transfer[] memory){
        return transactions;
    }

    function getTransactionCount() public view returns (uint) {
        return transactionCount;
    }

}