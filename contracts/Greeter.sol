// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

contract Greeter {
    string public yourName;
    constructor() {
        yourName = "World";
    }
    function set(string calldata name) public {
        yourName = name;
    }
    function hello() public view returns (string memory){
        return yourName;
    }
}

contract SimpleStorage {
    uint storedData;
    function set(uint x) public {
        storedData = x;
    }

    function get() public view returns (uint) {
        return storedData;
    }

    function increment(uint n) public {
        storedData += n;
    }

    function decrement(uint n) public {
        storedData -= n;
    }
}

contract Bidder {
    string public name;
    uint public bidAmount = 20000;
    bool public eligible;
    uint constant MIN_BID = 1000;

    function setName(string calldata nm) public {
        name = nm;
    }

    function setBidAmount(uint x) public {
        bidAmount = x;
    }

    function determineEligibility() public {
        if(bidAmount >= MIN_BID) eligible = true;
        else eligible = false;
    }

}

contract Coin{
    address public minter;
    mapping (address => uint) public balances;

    event Sent(address from, address to, uint amount);

    constructor(){
        minter = msg.sender;
    }

    function mint(address receiver, uint amount) public {
        if(msg.sender == minter){
            balances[receiver] += amount;
        }
    }

    function send(address receiver, uint amount) public {
        if(balances[msg.sender] > amount){
            balances[msg.sender] -= amount;
            balances[receiver] += amount;
            emit Sent(msg.sender, receiver, amount);
        }
    }
}

contract Ballot {
    struct Voter{
        uint weight;
        bool voted;
        uint8 vote;
        bool registed;
        address delegate;
    }
    struct Proposal{
        uint voteCount;
    }
    enum Stage {Init, Reg, Vote, Done}
    Stage public stage = Stage.Init;
    address public chairperson;
    mapping(address => Voter) public voters;
    Proposal[] proposals;
    uint startTime;
    
    modifier validStage(Stage reqStage){
        require(stage == reqStage);
        _;
    }

    event votingCompleted();

    constructor (uint8 _numProposals) {
        chairperson = msg.sender;
        Voter memory chairman = Voter(2, false, 0, true, address(0));
        voters[chairperson]= chairman;
        for (uint8 i = 0; i < _numProposals; i++){
            proposals.push();
        }
        stage = Stage.Reg;
        startTime = block.timestamp;
    }

    function register(address toVoter) validStage(Stage.Reg) public {
        if(!voters[toVoter].registed && msg.sender == chairperson){
            Voter memory voter = Voter(1, false, 0, true, address(0));
            voters[toVoter] = voter;
            if(block.timestamp > (startTime + 20 seconds)) {
                stage = Stage.Vote;
                startTime = block.timestamp;
            }
        }
    }

    function vote(uint8 toProposal) validStage(Stage.Vote) public {
        Voter storage sender = voters[msg.sender];
        if(sender.registed && !sender.voted && toProposal < proposals.length && toProposal >= 0){
            sender.voted = true;
            sender.vote = toProposal;
            proposals[toProposal].voteCount += sender.weight;
            if(block.timestamp > startTime + 20 seconds) {stage = Stage.Done; emit votingCompleted();}
        }
    }

    function winningProposal() validStage(Stage.Done) public view returns (uint8 _winningProposal) {
        uint winningVoteCount = 0;
        for (uint8 prop = 1; prop < proposals.length; prop++){
            if(proposals[prop].voteCount > winningVoteCount){
                winningVoteCount = proposals[prop].voteCount;
                _winningProposal = prop;
            }
        }
        assert(winningVoteCount > 0);
    }
}

contract StateTrans{
    enum Stage {Init, Reg, Vote, Done}
    Stage public stage;
    uint startTime;
    uint public timeNow;

    constructor() {
        stage = Stage.Init;
        startTime = block.timestamp;
    }

    function advance() public {
        timeNow = block.timestamp;
        if(timeNow > (startTime + 10 seconds)){
            startTime = timeNow;
            if(stage == Stage.Init) {stage = Stage.Reg; return;}
            if(stage == Stage.Reg) {stage = Stage.Vote; return;}
            if(stage == Stage.Vote) {stage = Stage.Done; return;}
        }
    }
}