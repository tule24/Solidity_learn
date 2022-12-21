// SPDX-License-Identifier: MIT
pragma solidity 0.8.7;
import "./ERC20.sol";

contract CPAMM{
    IERC20 public immutable token0;
    IERC20 public immutable token1;

    uint public reserve0;
    uint public reserve1;

    uint public totalSupply;
    mapping(address => uint) public balanceOf;

    constructor(address _token0, address _token1){
        token0 = IERC20(_token0);
        token1 = IERC20(_token1);
    }

    function _mint(address _to, uint _amount) private{
        balanceOf[_to] += _amount;
        totalSupply += _amount;
    }

    function _burn(address _from, uint _amount) private{
        balanceOf[_from] -= _amount;
        totalSupply -= _amount;
    }

    function _update(uint _reserve0, uint _reserve1) private{
        reserve0 = _reserve0;
        reserve1 = _reserve1;
    }

    function swap(address _tokenIn, uint _amountIn) external returns(uint amountOut){
        require(_tokenIn == address(token0) || _tokenIn == address(token1), "Invalid token");
        require(_amountIn > 0, "amountIn = 0");

        // pull in token in
        bool isToken0 = _tokenIn == address(token0);
        (IERC20 tokenIn, IERC20 tokenOut, uint resIn, uint resOut) = isToken0
        ? (token0, token1, reserve0, reserve1)
        : (token1, token0, reserve1, reserve0);
        tokenIn.transferFrom(msg.sender, address(this), _amountIn);

        // caculate token out (include fee 0.3%)
        // dy = ydx / (x + dx)
        uint amountIn = (_amountIn * 997) / 1000;
        amountOut = amountIn * resOut / (resIn + amountIn);

        // transfer token out to msg.sender
        tokenOut.transfer(msg.sender, amountOut);

        // update the reserves
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function addLiquidity(uint _amount0, uint _amount1) external returns (uint shares){
        // pull in token0 and token1
        token0.transferFrom(msg.sender, address(this), _amount0);
        token1.transferFrom(msg.sender, address(this), _amount1);
        
        // dy/dx = y/x
        if(reserve0 > 0 || reserve1 > 0){
            require(reserve0 * _amount1 == reserve1 * _amount0, "dy / dx != y/x");
        }

        // mint shares
        // f(x,y) = value of liquidity = sqrt(xy)
        // s = dx / x * T = dy / y * T  
        if(totalSupply == 0){
            shares = _sqrt(_amount0 * _amount1);
        }else {
            shares = _min(
                (_amount0 * totalSupply) / reserve0,
                (_amount1 * totalSupply) / reserve1
            );
        }
        require(shares > 0, "shares = 0");
        _mint(msg.sender, shares);

        // update reserves
        _update(
            token0.balanceOf(address(this)),
            token1.balanceOf(address(this))
        );
    }

    function removeLiquidity(uint _shares) external returns(uint amount0, uint amount1){
        // caculate amount0 and amount1 to withdraw
        // dx = s / T * x
        // dy = s / T * y
        uint bal0 = token0.balanceOf(address(this));
        uint bal1 = token1.balanceOf(address(this));

        amount0 = (_shares * bal0) / totalSupply;
        amount1 = (_shares * bal1) / totalSupply;
        require(amount0 > 0 && amount1 > 0, "amount0 or amount1 = 0");

        // burn shares
        _burn(msg.sender, _shares);

        // update reserves
        _update(bal0 - amount0, bal1 - amount1);

        // transfer tokens to msg.sender
        token0.transfer(msg.sender, amount0);
        token1.transfer(msg.sender, amount1);
    }

    function _sqrt(uint x) private pure returns (uint y) {
        uint z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }

    function _min(uint x, uint y) private pure returns(uint){
        return x <= y ? x : y;
    }
}