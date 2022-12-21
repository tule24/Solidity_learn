// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

// LOTTERY PROJECT
// Global variables: owner, players
// Functions: buy lottery, pick winner, get random number, withdraw
// (Option): get pot balance, get players, other()
contract Lottery {
    address public owner;
    uint public numberAward;
    struct Player{
        uint playerId;
        address playerAddress;
        uint playerNumber;
    }
    Player[] public Players;
    uint[] public WinnerPlayersId;
    enum Status{
        Start,
        RandomNumber,
        PickWinner,
        End
    }
    Status public status;
    modifier onlyOwner(){
        require(owner ==  msg.sender, "Not owner!!");
        _;
    }
    modifier verifyStatus(Status _status){
        require(status == _status, "Not allow this action in this status");
        _;
    }

    event BuyLottery(address indexed buyer);
    event GetLotteryNumber(uint number);
    constructor(){
        owner = msg.sender;
    }

    function buy(uint number) external payable verifyStatus(Status.Start) {
        require(msg.value > 0.01 ether, "You must send 0.01 ether to buy lottery");
        uint refund = msg.value - 10000000000000000;
        if(refund > 0){
            payable(msg.sender).transfer(refund);
        }
        Player memory player = Player(Players.length, msg.sender, number);
        Players.push(player);
    }

    function getLotteryBalances() view external onlyOwner returns (uint){
        return address(this).balance;
    }

    function getLotteryAward() view public returns (uint){
        return address(this).balance * 90 / 100;
    } 

    function getRandomNumber() external onlyOwner verifyStatus(Status.Start) {
        require(numberAward == 0, "Number award are availabel!!!");
        numberAward = uint(keccak256(abi.encodePacked(owner, block.timestamp, block.difficulty))) % 10;
        emit GetLotteryNumber(numberAward);
        status = Status.RandomNumber;
    }

    function pickWinner() external payable verifyStatus(Status.RandomNumber){
        for(uint i = 0; i < Players.length; i++){
            if(Players[i].playerNumber == numberAward){
                WinnerPlayersId.push(i);
            }
        }
        if(WinnerPlayersId.length > 0){
            uint reward = getLotteryAward()/WinnerPlayersId.length;
            for(uint i = 0; i < WinnerPlayersId.length; i++){
                payable(Players[WinnerPlayersId[i]].playerAddress).transfer(reward);
            }
        }
        status = Status.PickWinner;
    }

    function withdraw() external onlyOwner verifyStatus(Status.PickWinner){
        if(WinnerPlayersId.length > 0){
            payable(owner).transfer(address(this).balance);
        } else {
            payable(owner).transfer(address(this).balance * 10 / 100);
        }
    }
}