// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Array - dynamic or fixed size
// Initialization
// Insert (push), get, update, delete, pop, length
// Creating array in memory
// Returning array from function

contract Array {
    uint[] public nums = [1, 2, 3];
    uint[3] public numsFixed = [4, 5, 6];

    function examples() external {
        nums.push(4); // [1, 2, 3, 4]
        uint x = nums[3]; // 4
        nums[2] = 777; // [1, 2, 777, 4]
        delete nums[1]; // [1, 0, 777, 4]
        nums.pop(); // [1, 0, 777]
        uint len = nums.length; // 3

        //create array in memory
        uint[] memory a = new uint[](5); // tạo mảng trong memory phải có chiều dài xác định
        // đối với loại mảng này mình chỉ có thể lấy hoặc update giá trị
        a[1] = 123;
    }

    function returnArray() external view returns (uint[] memory){ 
            // Ở đây thì ta nói với solidity là ta sẽ lưu nums vào memory, rồi từ memory mình return lại nums 
            // Không khuyến khích viết hàm trả về array vì nó sẽ tốn rất nhiều gas tùy theo arr
            return nums;
        }
}