// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
/* pure, view chỉ dùng để đọc
// Func có 2 loại
// - Func create transaction => các func ghi dữ liệu lên blockchain: thay đổi state variable, thay đổi số dư, chuyển khoản,..
// - Func no transaction (pure, view) => các func ko thay đổi trạng thái của blockchain: func đọc và trả về trạng thái của blockchain
// Một số kiểu dữ liệu không nên hoặc ko thể dùng làm input/output cho func
//  - Invalid inputs for functions: 
        + {} map
        + [][] multi-dimensional arrays (unfixed size) => phiên bản 0.8 thì vẫn dùng được
    - Invalid outputs for functions:
        + {} map

=> Hạn chế sử dụng arr unfixed làm đầu vào hoặc đầu ra vì phí gas sẽ rất cao
*/
contract FunctionIntro{
    function add(uint x, uint y) external pure returns(uint){
        return x + y;
    }

    function sub(uint x, uint y) external pure returns(uint){
        return x-y;
    }

    // function mapInput(mapping(uint => address) memory map) public {

    // }

    // function multiArray(uint[][] memory _arr) public {

    // }

    mapping (uint => string) map;
    uint[] arr;
    uint[9][9] arr2DFixed;
    uint[][] arr2D;

    // function mapOutput() private view returns (mapping(uint => string) memory){
    //     return map;
    // } 
    function arrOutput() public view returns (uint[] memory){
        return arr;
    }
    function arr2DFixedOutput() public view returns (uint[9][9] memory){
        return arr2DFixed;
    }
    function arr2DOutput() public view returns (uint[][] memory){
        return arr2D;
    }
}