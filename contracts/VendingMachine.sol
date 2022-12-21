// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// VENDING MACHINE PROJECT
// State variables: owner, balances
// Functions: purchase, restock, get balance
// Constructor: set owner, set initial balance of vending machine

contract VendingMachine{
    address public owner;
    mapping (address => uint) public donutBalances;

    modifier onlyOwner(){
        require(msg.sender == owner, "Not owner!!");
        _;
    }
    modifier verifyPurchase(uint amount){
        require(msg.value >= amount * 2 ether, "You must pay at least 2 ether/donut");
        require(donutBalances[address(this)] >= amount, "Not enough donuts in stock to fulfill request");
        _;
    }

    event Restock(uint indexed amount);
    event Purchase(address indexed buyer, uint amount);

    constructor(){
        owner = msg.sender;
        donutBalances[address(this)] = 1000; // => this ở đây là chỉ contract ko phải chỉ người gọi
    }

    function getVendingMachineBalance() public view returns(uint){
        return donutBalances[address(this)];
    }

    function restock(uint amount) public onlyOwner{
        donutBalances[address(this)] += amount;
        emit Restock(amount);
    } 

    function purchase(uint amount) public payable verifyPurchase(amount){
        donutBalances[address(this)] -= amount;
        donutBalances[msg.sender] += amount;
        emit Purchase(msg.sender, amount);
    }

    function getBalance() public view returns(uint){
        return donutBalances[msg.sender];
    }

}