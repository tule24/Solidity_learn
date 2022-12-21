// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import "./ComptrollerInterface.sol";
import "./CTokenInterface.sol";

contract MyDefiProject{
    IERC20 dai;
    CTokenInterface cDai;
    IERC20 bat;
    CTokenInterface cBat;
    ComptrollerInterface comptroller;

    constructor(address _dai, address _cDai, address _bat, address _cBat, address _comptroller){
        dai = IERC20(_dai);
        cDai = CTokenInterface(_cDai);
        bat = IERC20(_bat);
        cBat = CTokenInterface(_cBat);
        comptroller = ComptrollerInterface(_comptroller);
    }

    function invest() external{
        dai.approve(address(cDai), 10000);
        cDai.mint(10000);
    }

    function cashOut() external {
        uint balance = cDai.balanceOf(address(this));
        cDai.redeem(balance);
    }

    function borrow() external{
        dai.approve(address(cDai), 10000);
        cDai.mint(10000);

        address[] markets = new address[](1);
        markets[0] = cDai;
        comptroller.enterMarkets(markets);

        cBat.borrow(100);
    }

    function payback() external{
        bat.approve(address(cBat), 200);
        cBat.repayBorrow(100);
    }
}