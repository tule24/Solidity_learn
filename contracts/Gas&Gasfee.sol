// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// TxFee = gas used * gas price
/* Ví dụ: Update dữ liệu kích thước (Number of Operations): 8
        5 gas / operation
        8 operation * 5 gas = 40 gas
    => Gas fee
    -- Tỉ lệ thuận với số lượng tính toán (computation)
    -- Tỉ lệ nghịch với thời gian chờ (waiting time) => các giao dịch khi đưa lên blockchain thì các thợ đào sẽ validate các 
    giao dịch này. Giao dịch nào trả phí nhiều thì họ ưu tiên làm verify trước => giao dịch thực hiện càng nhanh thì phí gas
    càng cao.

    Send with Tx
        - Gas limit - max gas you're willing to use
            + gas limit: mình tự set
            + block gas limit: set by network
        - Gas price - how much ether you're willing to pay for 1 gas
        - Ether - gas limit * gas price

    Example: gas limit: 3000
             gas price: 2 gwei
         =>  ether: 3000 gas * 2 (gwei/gas) = 6000 gwei
         => Khi thực hiện transaction thì gas fee thực tế sử dụng là 1000 gas
         => transaction fee: 2000 gwei
        
*/