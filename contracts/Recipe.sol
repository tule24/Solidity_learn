// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ContractA{
    function foo(uint arg) external{}
}

contract ContractB {
    function bar(uint arg) external{}
}

contract ContractC {
    function groupExecute(uint argA, uint argB) external{
        //ContractA(...0x).foo(argA);
        //ContractB(...0x).bar(argB);
    }
}

//---------------------------------------------------------
contract Factory{
    Child[] public children;
    event ChildCreated(
        uint date,
        uint data,
        address childAddress
    );
    function createChild(uint _data) external{
        Child child = new Child(_data);
        children.push(child);
        emit ChildCreated(block.timestamp, _data, address(child));
    }
}

contract Child {
    uint data;
    constructor(uint _data){
        data = _data;
    }
}

//---------------------------------------------------------
contract Myarr{
    string[] public data;

    constructor(){
        data.push("Anna");
        data.push("Bone");
        data.push("Penny");
        data.push("Santos");
        data.push("Zoro");
    }

    function removeNoOrder(uint index) external{
        data[index] = data[data.length - 1];
        data.pop(); 
    }

    function removeInOrder(uint index) external{
        for(uint i = index; i < data.length - 1; i++){
            data[i] = data[i+1];
        }
        data.pop();
    }
}

//---------------------------------------------------------
contract Collection{
    struct User{
        uint id;
        string name;
    }
    //User[] users;
    mapping(uint => User) users;
    uint nextUserId;

}

//---------------------------------------------------------
contract Collections{
    struct User{
        address userAddress;
        uint balance;
    }
    User[] users;

    function getUsers1() external view returns(address[] memory, uint[] memory){
        uint len = users.length;
        address[] memory userAddresses = new address[](len);
        uint[] memory balances = new uint[](len);

        for(uint i = 0; i < len; i++){
            userAddresses[i] = users[i].userAddress;
            balances[i] = users[i].balance;
        }
        return (userAddresses, balances);
    }

    function getUsers2() external view returns(User[] memory){
        return users;
    }
}

//---------------------------------------------------------
contract Oracle {
    address admin;
    uint rand;
    constructor(){
        admin = msg.sender;
    }

    function feedRandom(uint _rand) external {
        require(msg.sender == admin);
        rand = _rand;
    }
}
contract Random{
    Oracle oracle;
    uint nonce;
    constructor(address oracleAddress) {
        oracle = Oracle(oracleAddress);
    }
    function foo() external{
        uint rand = _randModulus(10);
        //use rend however you want
    }
    function _randModulus(uint mod) internal returns(uint){
        uint rand = uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % mod;
        nonce++;
        return rand;
    }
}

//---------------------------------------------------------
contract MyString{
    function length(string calldata str) external pure returns(uint){
        return bytes(str).length;
    }
    function concat(string calldata str1, string calldata str2) external pure returns(string memory){
        return string(abi.encodePacked(str1, str2));
    }
    function reverse(string calldata _str) external pure returns(string memory){
        bytes memory str = bytes(_str);
        string memory tmp = new string(str.length);
        bytes memory _reverse = bytes(tmp);

        for(uint i = 0; i < str.length; i++){
            _reverse[str.length - i - 1] = str[i];
        }
        return string(_reverse);
    }

    function test(string calldata _str) external pure returns(bytes memory, string memory, bytes memory, uint){
        bytes memory str = bytes(_str);
        string memory tmp = new string(str.length);
        bytes memory _reverse = bytes(tmp);
        uint len = bytes(tmp).length;
        return (str, tmp, _reverse, len);
    }

    function test2(string calldata str) external pure returns(bytes1){
        return bytes(str)[0];
    }

    function compare(string calldata a, string calldata b) external pure returns(bool){
        return keccak256(abi.encodePacked(a)) == keccak256(abi.encodePacked(b));
    }
}

//---------------------------------------------------------
contract Token{
    function transfer(uint amount, address to) external{

    }
}

contract Registry{
    mapping(string => address) public tokens;
    address admin;

    constructor() public {
        admin = msg.sender;
    }

    function updateToken(string calldata id, address tokenAddress) external {
        require(msg.sender == admin);
        tokens[id] = Token(tokenAddress);
    }

    function foo() external {
       // token.transfer(100, msg.sender);
    }
}

contract A{
    Registry registry;
    address admin;
    constructor(){
        admin = msg.sender;
    }

    function updateRegistry(address registryAddress) external{
        require(msg.sender == admin);
        registry = Registry(registryAddress);
    }

    function foo() external{
        Token token = Token(registry.tokens["ABC"]);
        token.transfer(100, msg.sender);
    }
}

contract B{
    Token token;
    address admin;
    constructor(){
        admin = msg.sender;
    }

    function updateToken(address tokenAddress) external{
        require(msg.sender == admin);
        token = Token(tokenAddress);
    }

    function foo() external{
        token.transfer(100, msg.sender);
    }
}

//---------------------------------------------------------
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
contract MyToken is ERC20{
    constructor(string memory name, string memory symbol) ERC20(name, symbol){}
    function mint(address recipient, uint amount) external{
        _mint(recipient, amount);
    }
}

//---------------------------------------------------------
contract WETH is ERC20{
    constructor() ERC20("Wrapped Ether", "WETH"){}

    function mint() external payable{
        transferFrom(msg.sender, address(this));
        _mint(msg.sender, msg.value);
    }

    function burn(uint amount) external{
        transfer(msg.sender, amount);
        msg.sender.transfer(amount);
        _burn(msg.sender, amount);
    }
}

//---------------------------------------------------------
contract ExchangeA {
    function priceForToken(address token) external view returns(uint);
    function enterTrade(address token, uint amount) external returns(uint);
}
contract ExchangeB {
    function getPriceForToken(address token) external view returns(uint);
    function executeTrade(address token, uint amount) external returns(uint);
}

contract Adapter{
    ExchangeA exchangeA;
    ExchangeB exchangeB;

    constructor(address exchangeAAddress, address exchangeBAddress){
        exchangeA = ExchangeA(exchangeAAddress);
        exchangeB = ExchangeB(exchangeBAddress);
    }

    function getBestExchangeFor(address token) external view returns (address){
        uint priceA = exchangeA.priceForToken(token);
        uint priceB = exchangeB.getPriceForToken(token);
        return priceA > priceB ? address(exchangeB) : address(exchangeA);
    }

    function invest(uint amount, address token, address exchange) external {
        
    }
}
contract MyContract{
    Adapter adapter;
    Token token;

    constructor(address tokenAddress) {
        token = Token(tokenAddress);
    }

    function updateAdapter(address adapterAddress) external{
        adapter = Adapter(adapterAddress);
    }

    function invest(uint amount) external{
        token.approve(address(adapter), amount);
        address bestExchange = adapter.getBestExchangeFor(address(token));
        adapter.invest(amount, address(token), bestExchange);
    }
}

//---------------------------------------------------------
contract MyDry{
    function A() external {
         _transferEther();
    }

    function B() external {
        _transferEther();
    }

    function _transferEther() internal{
        msg.sender.sender(100);
        //balances[msg.sender] -= 100;
    }
}

//---------------------------------------------------------
contract MyPercentage {
    function calculateFee(uint amount) external pure returns(uint) {
        require((amount/10000) * 10000 == amount, "too small");
        return (amount*185/1000);
    }
}

//---------------------------------------------------------
contract MyCir{
    bool isActive = true;
    address admin;
    constructor(){
        admin = msg.sender;
    }
    
    modifier contractIsActive(){
        require(isActive == true);
        _;
    }
    receive() external contractIsActive(isActive) payable{}

    function toggleCircuitBreaker() external contractIsActive(isActive){
        require(admin == msg.sender)
        isActive = !isActive;
    }

    function withdraw() external{}
}