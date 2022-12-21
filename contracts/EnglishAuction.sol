// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;

interface IERC721{
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract EnglishAuction{
    IERC721 public immutable nft;
    uint public immutable nftId;

    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed bidder, uint amount);
    event End(address highestBidder, uint amount);

    address payable public immutable seller;
    uint32 public endAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid; 
    mapping(address => uint) public bids;

    constructor(address _nft, uint _nftId, uint _startingBid){
        nft = IERC721(_nft);
        nftId = _nftId;
        seller = payable(msg.sender);
        highestBid = _startingBid;
    }

    function start() external {
        require(msg.sender == seller, "not seller");
        require(!started, "started");
        started = true;
        endAt = uint32(block.timestamp + 120);
        nft.transferFrom(seller, address(this), nftId);

        emit Start();
    }

    function bid() external payable{
        require(started, "not started");
        require(block.timestamp < endAt, "Auction is ended");
        require(bids[msg.sender] + msg.value > highestBid, "total your bid < highest bid");
        require(msg.sender != address(0), "Address invalid");

        highestBid = bids[msg.sender] + msg.value;
        highestBidder = msg.sender;
        bids[highestBidder] = highestBid;
        
        emit Bid(msg.sender, highestBid);
    }

    function withdraw() external{
        require(msg.sender == highestBidder, "You can't withdraw because you are highest bidder");
        require(bids[msg.sender] > 0, "Your balance is 0");
        uint bal = bids[msg.sender];
        bids[msg.sender] = 0;

        payable(msg.sender).transfer(bal); 
        emit Withdraw(msg.sender, bal);
    }

    function end() external{ 
    // func này để public vì đề phòng seller không end phiên đấu giá khi kết thúc, 
    // tiền của người đấu giá cao nhất bị kẹt trong hợp đồng mà nft thì vẫn thuộc về hợp đồng này
        require(started, "not started");
        require(!ended, "ended");
        require(block.timestamp < endAt, "Auction time is still on!");

        ended = true;
        if(highestBidder != address(0)){
            nft.transferFrom(address(this), highestBidder, nftId);
            seller.transfer(highestBid);
        } else {
            nft.transferFrom(address(this), seller, nftId);
        }

        emit End(highestBidder, highestBid);
    }
}