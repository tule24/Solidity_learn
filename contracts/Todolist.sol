// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

// Insert, update, read from array of structs
contract Todolist{
    struct Todo{
        string text;
        bool completed;
    }

    Todo[] public todos;

    function create(string calldata _text) external{
        todos.push(Todo({
            text: _text,
            completed: false
        }));
    }
    function updateText(uint _index, string calldata _text) external{
        require(_index < todos.length, "Index must be less than todos.length");
        todos[_index].text = _text;
        // 35138 gas
        // todos[_index].text = _text;
        // todos[_index].text = _text;
        // todos[_index].text = _text;
        // todos[_index].text = _text;

        //34578 gas
        // Todo storage todo = todos[_index];
        // todo.text = _text;
        // todo.text = _text;
        // todo.text = _text;
        // todo.text = _text;

        // => Nếu chỉ cập nhật 1 lần cách 1 sẽ gọn và tiết kiệm, còn nếu cập nhật nhiều lần thì cách 2 sẽ tiết kiệm hơn
        // Vì cách 1 mình truy cập mảng 4 lần, còn cách 2 mình chỉ gọi lấy địa chỉ tham chiếu 1 lần và gán lại 4 lần
    }
    function get(uint _index) external view returns(string memory, bool){
        //storage - 29397
        //memory - 29480
        Todo memory todo = todos[_index];
        return (todo.text, todo.completed);
    }

    function toggleCompleted(uint _index) external{
        todos[_index].completed = !todos[_index].completed;
    }
}