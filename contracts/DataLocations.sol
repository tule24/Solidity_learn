// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Data locations - storage, memory and calldata
// storage nghĩa là biến đó là state variable
// memory nghĩa là biến đó được lưu vào bộ nhớ
// calldata giống memory nhưng nó chỉ được sử dụng làm đầu vào cho các func để tiết kiệm gas (xuất hiện trong external func)

// Storage: global, permanent, state vars
// Memory: local, temporary, local vars, arguments

// Storage (permanent) => được lưu trên blockchain
// Memory (while function call)
// Calldata

// Việc lưu trữ dữ liệu trên blockchain là vô cùng tốn kém, nên có cách khác để giải quyết vấn đề này là sử dụng IPFS
// IPFS là một nơi lưu trữ tệp ngang hàng (peer-to-peer), và bất kỳ ai cũng có thể truy cập bằng cách
// biết hàm băm của dữ liệu => Mình tải dữ liệu lên IPFS, mình lấy được một mã hash là vị trí lưu trữ dữ liệu của mình
// và trong contract mình https://ipfs.io/ipfs/{mã hash}
// => giúp lưu trữ dữ liệu lớn với phí gas rẻ, public được dữ liệu của mình
contract DataLocations{
    struct MyStruct{
        uint foo;
        string text;
    }

    mapping(address => MyStruct) public myStructs;
    function examples(uint[] calldata y, string calldata s) external returns (uint[] memory){
        myStructs[msg.sender] = MyStruct({foo: 123, text: "bar"});
        MyStruct storage myStruct = myStructs[msg.sender]; // muốn cập nhật chỉnh sửa nó thì xài storage
        myStruct.text = "abc";

        MyStruct memory readOnly = myStructs[msg.sender]; // muốn get dữ liệu thôi thì xài memmory
        readOnly.foo = 456; // trong hàm thì nó vẫn là 456, nhưng sau khi thoát hàm nó trở về 123
        //return readOnly;

        _internal(y);

        uint[] memory memArr = new uint[](3);
        memArr[0] = 234;
        return memArr;
    }

    function _internal(uint[] calldata y) pure private {
        uint x = y[0];
    }
}