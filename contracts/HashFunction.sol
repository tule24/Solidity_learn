// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

/* Kaccak256 (Cryptographic Hash Function)
    - Function that takes in arbitrary size input and outputs a data of fixed size
    - properties
        + deterministic
            hash(x) = h, every time
        + quick to compute the hash
        + irreversible
            given h, hard to find x such that hash(x) = h
        + small change in input changes the output significantly
        + collision resistant
            hard to find x, y such that hash(x) = hash(y)
Examples:
    - Guessing game (pseudo random)

Khác biệt giữa abi.encode & abi.encodePacked
 => Cùng 1 đầu vào thì encodePacked sẽ nén dữ liệu trả về lại nên sẽ gọn hơn encode
*/

contract HashFunction{
    function hash(string memory _text, string memory _another /*uint _num, address _addr*/) public pure returns (bytes32){
       // return keccak256(abi.encodePacked(_text, _num, _addr));
       return keccak256(abi.encodePacked(_text, _another)); // tránh xung đột khi nối nhiều chuỗi thì nên dùng abi.encode
    }
    // AAA BBB => AAABBB
    // AA ABBB => AAABBB
    // => Đầu vào khác nhau nhưng encodePacked sẽ cho ra cùng 1 kết quả nhưng nếu dùng encode thì kết quả sẽ khác nhau
    function collision(string memory text0, uint x, string memory text1) external pure returns(bytes32 ){
        //return keccak256(abi.encodePacked(text0,x, text1));
        return keccak256(abi.encode(text0, text1));
    }
}

contract GuessTheMagicWord{
    bytes32 public answer = 0x7878cdd5116195def30a62dfa25eb58c8be606b1e1b7f9161e039be52a892cdf;
    function guess(string memory _word) public view returns (bool){
        return keccak256(abi.encodePacked(_word)) == answer;
    }
}
//0x72c447c04549d295c6376ff36ed7eaeeaed43023f856de4277b1d5c410000035
//0x7878cdd5116195def30a62dfa25eb58c8be606b1e1b7f9161e039be52a892cdf