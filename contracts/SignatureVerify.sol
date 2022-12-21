// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Signature Verification
How to Sign and Verify Messages

    #Signing
    1. Create message to sign
    2. Hash the message
    3. Sign the hash (off chain, keep your private key secret)

    #Verify
    1. Recreate hash from the original message
    2. Recover signer from signature and hash
    3. Compare recovered signer to claimed signer 
*/

contract VerifySignature{
    function getMessageHash(address _to, uint _amount, string memory _message, uint _nonce) public pure returns (bytes32){
        return keccak256(abi.encodePacked(_to, _amount, _message, _nonce));
    }

    /*
    Signature is produced by signing a keccak256 hash with the following format: 
    "\x19Ethereum Signed Message\n" + len(msg) + msg // 32 byte đầu dùng để mã hóa độ dài message
    \x19Ethereum Signed Message\n32...message hash goes here... 
    */

    function getEthSignedMessageHash(bytes32 _messageHash) public pure returns (bytes32){
        return keccak256(abi.encodePacked(
            "\x19Ethereum Signed Message:\n32",
            _messageHash
        ));
    }

    function veirfy(
        address _signer,
        address _to, uint _amount, string memory _message, uint _nonce,
        bytes memory _signature
    ) public pure returns (bool){
        bytes32 messageHash = getMessageHash(_to, _amount, _message, _nonce);
        bytes32 ethSignedMessageHash = getEthSignedMessageHash(messageHash);
        return recoverSigner(ethSignedMessageHash, _signature) == _signer;
    }

    function recoverSigner(
        bytes32 _ethSignedMessageHash, bytes memory _signature
    ) public pure returns (address){
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(_signature);
        return ecrecover(_ethSignedMessageHash, v, r, s);
    }

    function splitSignature(bytes memory _sig) public pure returns(bytes32 r, bytes32 s, uint8 v){
        require(_sig.length == 65, "invalid signature length");
        assembly{
            r := mload(add(_sig, 32))
            // add(_sig, 32) => _sig là kiểu dữ liệu động => những gì lưu trữ trong biến _sig là một pointer trỏ đến nơi lưu chữ ký
            // vị trí bắt đầu lưu trữ trong bộ nhớ => khi truy cập ta bỏ qua 32 byte đầu tiên vì 32 byte đầu dùng để lưu độ dài mảng động
            // mload(p) bỏ qua 32 byte tiếp theo bắt đầu tại địa chỉ p
            s := mload(add(_sig, 64))
            v := byte(0, mload(add(_sig, 96)))
        }
    }
    // # using browser
    // account = "copy paste account of signer here"
    // ethereum.request({ method: "personal_sign", params: [account, hash]}).then(console.log)

    // # using web3
    // web3.personal.sign(hash, web3.eth.defaultAccount, console.log)
        
}