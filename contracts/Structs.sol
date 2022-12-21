// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Structs{
    struct Car {
        string model;
        uint year;
        address owner;
    }

    Car public car;
    Car[] public cars;
    mapping(address => Car[]) public carsByOwner;

    //Có 3 cách khởi tạo cho biến cấu trúc
    function examples() external {
        Car memory toyota = Car("Toyota", 1990, msg.sender); // truyền đúng thứ tự theo cấu trúc đã khai báo
        Car memory lambo = Car({year: 1980, model: "Lamborghini", owner: msg.sender}); // truyền dưới dạng obj, đúng key, ko cần đúng thứ tự
        Car memory tesla; // các giá trị sẽ khởi tạo với giá trị mặc định
        tesla.model = "Tesla";
        tesla.year = 2010;
        tesla.owner = msg.sender;

        cars.push(toyota);
        cars.push(lambo);
        cars.push(tesla);

        //memory nghĩa là chúng ta tải dữ liệu này vào bộ nhớ, vì vậy khi chúng ta sửa đổi bất cứ thứ gì liên quan, thì khi thực hiện xong func sẽ ko lưu giá trị lại
        //storage nghĩa là chúng ta muốn truy cập và update lại nội dung được lưu trong contract
        cars.push(Car("Ferrari", 2019, msg.sender));
        Car memory _car = cars[0];
        _car.year = 1999;

        delete _car.owner;
        delete cars[1];
    }

    function get(uint _index) public view returns(string memory, uint , address){ // trả về dạng tuple nếu returns struct
        Car memory carA = cars[_index];
        return (carA.model, carA.year, carA.owner);
    }
}