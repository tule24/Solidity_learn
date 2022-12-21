// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";

contract MultiSigWallet {
    /*--------------EVENT-----------*/
    event Deposit(string ticker, address indexed sender, uint256 amount);
    event AddToken(address indexed owner, string ticker, address tokenAddress);
    event TxSubmit(
        uint256 indexed txId,
        address indexed sender,
        address to,
        string ticker,
        uint256 value
    );
    event ChangeSubmit(
        uint256 indexed changedId,
        address indexed sender,
        address[] delOwner,
        address[] addOwner,
        uint256 _approvalsRequired
    );
    event Voted(
        uint256 indexed txId,
        address indexed owner,
        bool isApproved
    );
    event Success(uint256 indexed txId);
    event Failed(uint256 indexed txId);

    /*-------------STORAGE-------------*/
    address multiSigFactory;
    uint256 public id;

    struct Consensus {
        uint256 totalOwner;
        uint256 approvalsRequired;
    }
    Consensus public consensus;
    mapping(address => bool) public isOwner;

    enum State{
        Pending,
        Success,
        Fail
    }
    struct IdInfo{
        State state;
        uint256 totalApproval;
        uint256 totalReject;
    }

    struct ChangeInfo {
        uint id;
        address[] delOwners;
        address[] addOwners;
        uint256 approvalsRequired;
    }
    ChangeInfo public changeInfo;
    bool isChanging;

    uint public transactionPending;
    struct Transaction {
        address to;
        string ticker;
        uint256 value;
    }

    mapping(uint256 => Transaction) public transactions;
    mapping(uint256 => mapping(address => bool)) public voted;
    mapping(uint256 => IdInfo) public idInfo;

    struct Token {
        address tokenAddress;
        uint256 balance;
    }
    mapping(string => Token) public tokenMapping;

    /*-------------MODIFIER-------------*/
    modifier onlyOwner() {
        require(isOwner[msg.sender], "not owner");
        _;
    }
    modifier isChangeExists(uint256 _id){
        require(_id == changeInfo.id, "changeID not exist");
        _;
    }
    modifier isIdExists(uint256 _id) {
        require(_id <= id, "not exist id");
        _;
    }
    modifier notVoted(uint256 _id) {
        require(!voted[_id][msg.sender], "user already voted");
        _;
    }
    modifier notExecuted(State _state) {
        require(_state == State.Pending, "already executed");
        _;
    }
    modifier tokenExists(string memory ticker) {
        require(
            tokenMapping[ticker].tokenAddress == address(0),
            "token is exists"
        );
        _;
    }

    /*-------------CONSTRUCTOR-------------*/
    constructor(address[] memory _owners, uint256 _required, address _multiSigFactory) {
        require(_owners.length > 0, "owners required");
        require(
            _required > 0 && _required <= _owners.length,
            "invalid required number of owners"
        );
        uint256 count;
        for (uint256 i; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "invalid owner");
            require(!isOwner[owner], "owner is exist");
            isOwner[owner] = true;
            count++;
        }

        consensus.totalOwner += count;
        consensus.approvalsRequired = _required;

        tokenMapping["ETH"] = Token({tokenAddress: address(1), balance: 0});
        multiSigFactory = _multiSigFactory;
    }

    /*-------------FUNCTION-------------*/

    /*Deposit fn*/
    receive() external payable {
        emit Deposit("ETH", msg.sender, msg.value);
    }

    function deposit(string memory _ticker, uint256 amount)
        external
        payable
        onlyOwner
    {
        require(tokenMapping[_ticker].tokenAddress != address(0), "token not exists");
        bool success;
        if (keccak256(bytes("ETH")) == keccak256(bytes(_ticker))) {
            (success, ) = address(this).call{value: msg.value}("");
        } else {
            success = IERC20(tokenMapping[_ticker].tokenAddress).transferFrom(
                msg.sender,
                address(this),
                amount
            );
        }
        require(success, "deposit failed");
        tokenMapping[_ticker].balance += amount;
        emit Deposit(_ticker, msg.sender, amount);
    }

    /* Token */
    function addToken(string memory _ticker, address _tokenAddress)
        public
        onlyOwner
        tokenExists(_ticker)
    {
        require(_tokenAddress != address(0), "tokenAddress is invalid");
        require(
            keccak256(bytes(ERC20(_tokenAddress).symbol())) ==
                keccak256(bytes(_ticker)),
            "symbol not match tokenAddress"
        );
        tokenMapping[_ticker] = Token({
            tokenAddress: _tokenAddress,
            balance: 0
        });
        emit AddToken(msg.sender, _ticker, _tokenAddress);
    }

    /* Consensus */
    function changeSubmit(
        address[] calldata _delOwners,
        address[] calldata _addOwners,
        uint256 _approvalsRequired
    ) external onlyOwner {
        require(transactionPending == 0, "transaction pending");
        require(_approvalsRequired > 0, "approvalsRequired > 0");
        id += 1;
        changeInfo = ChangeInfo({
            id: id,
            delOwners: _delOwners,
            addOwners: _addOwners,
            approvalsRequired: _approvalsRequired
        });
        voted[id][msg.sender] = true;
        idInfo[id] = IdInfo({state: State.Pending, totalApproval: 1, totalReject: 0});
        isChanging = true;
        emit ChangeSubmit(
            id,
            msg.sender,
            _delOwners,
            _addOwners,
            _approvalsRequired
        );
    }

    function changeVote(uint256 _id, bool _isApproved)
        external
        onlyOwner
        isChangeExists(_id)
        notVoted(_id)
        notExecuted(idInfo[_id].state)
    {
        voted[_id][msg.sender] = true;
        IdInfo storage _idInfo = idInfo[_id];
        emit Voted(_id, msg.sender, _isApproved);

        if (_isApproved){
            _idInfo.totalApproval += 1;
        } else {
            _idInfo.totalReject += 1;
            if (_idInfo.totalReject > consensus.totalOwner - consensus.approvalsRequired){
                _idInfo.state = State.Fail;
                isChanging = false;
                emit Failed(_id);
            }
        }
    }

    function changeExecute(uint256 _id)
        external
        onlyOwner
        isChangeExists(_id)
        notExecuted(idInfo[_id].state)
    {
        IdInfo storage _idInfo = idInfo[_id];
        require(
            _idInfo.totalApproval >= consensus.approvalsRequired,
            "approvals < approvalsRequired"
        );
        
        MultiSigFactory factory = MultiSigFactory(multiSigFactory);
        uint delLength = changeInfo.delOwners.length;
        uint addLength = changeInfo.addOwners.length;
        if (delLength > 0) {
            for (uint256 i; i < delLength; i++) {
                address old_owner = changeInfo.delOwners[i];
                require(isOwner[old_owner], "not owner");
                delete isOwner[old_owner];
                factory.updateOwner(old_owner, address(this), false);
            }
            consensus.totalOwner -= delLength;
        } 
        if (addLength > 0)  {
            for (uint256 i; i < addLength; i++) {
                address new_owner = changeInfo.addOwners[i];
                require(!isOwner[new_owner], "owner already exist");
                isOwner[new_owner] = true;
                factory.updateOwner(new_owner, address(this), true);
            }
            consensus.totalOwner += addLength;
        }
        require(
            changeInfo.approvalsRequired <= consensus.totalOwner,
            "approvalsRequired <= totalOwner"
        );
        consensus.approvalsRequired = changeInfo.approvalsRequired;
        _idInfo.state = State.Success;
        isChanging = false;
        emit Success(_id);
    }

    /* Transaction */
    function submit(
        address _to,
        uint256 _value,
        string memory _ticker
    ) external onlyOwner {
        require(!isChanging, "is changing");
        id += 1;
        transactions[id] = Transaction({
            to: _to,
            ticker: _ticker,
            value: _value
        });
        voted[id][msg.sender] = true;
        idInfo[id] = IdInfo({state: State.Pending, totalApproval: 1, totalReject: 0});
        transactionPending += 1;
        emit TxSubmit(id, msg.sender, _to, _ticker, _value);
    }

    function approve(uint256 _id, bool _isApproved)
        external
        onlyOwner
        isIdExists(_id)
        notVoted(_id)
        notExecuted(idInfo[_id].state)
    {
        voted[_id][msg.sender] = true;
        IdInfo storage _idInfo = idInfo[_id];
        emit Voted(_id, msg.sender, _isApproved);

         if (_isApproved){
            _idInfo.totalApproval += 1;
        } else {
            _idInfo.totalReject += 1;
            if (_idInfo.totalReject > consensus.totalOwner - consensus.approvalsRequired){
                _idInfo.state = State.Fail;
                transactionPending -= 1;
                emit Failed(_id);
            }
        }
    }

    function execute(uint256 _id)
        external
        payable
        isIdExists(_id)
        notExecuted(idInfo[_id].state)
    {
        IdInfo storage _idInfo = idInfo[_id];
        Transaction memory transaction = transactions[_id];

        require(
            _idInfo.totalApproval >= consensus.approvalsRequired,
            "approvals < approvalsRequired"
        );
        require(
            tokenMapping[transaction.ticker].balance >= transaction.value,
            "insufficient balance"
        );

        bool success;
        tokenMapping[transaction.ticker].balance -= transaction.value;
        if (keccak256(bytes("ETH")) == keccak256(bytes(transaction.ticker))) {
            (success, ) = transaction.to.call{value: transaction.value}("");
        } else {
            success = IERC20(tokenMapping[transaction.ticker].tokenAddress)
                .transferFrom(address(this), transaction.to, transaction.value);
        }
        require(success, "tx failed");
        _idInfo.state = State.Success;
        transactionPending -= 1;
        emit Success(_id);
    }
}

contract MultiSigFactory {

    MultiSigWallet[] public multiSigWalletInstances;

    mapping(address => mapping(address => bool)) public ownerWallets;

    event WalletCreated(address createdBy, address newWalletContractAddress, address[] owners, uint256 required);

    function createNewWallet(address[] memory _owners, uint256 _required) external {
        MultiSigWallet newMultiSigWalletContract = new MultiSigWallet(_owners,  _required, address(this));
        multiSigWalletInstances.push(newMultiSigWalletContract);
        for (uint i; i < _owners.length; i++){
            ownerWallets[_owners[i]][address(newMultiSigWalletContract)] = true;
        }
        emit WalletCreated(msg.sender, address(newMultiSigWalletContract), _owners, _required);
    }

    function updateOwner(address changeOwner, address multiSigContractAddress, bool isAdd) external {
        if (isAdd){
            ownerWallets[changeOwner][multiSigContractAddress] = true;
        } else {
            ownerWallets[changeOwner][multiSigContractAddress] = false;
        }
    }
}