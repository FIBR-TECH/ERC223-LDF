pragma solidity ^0.4.24;

/**
 * @title IERC223
 * @dev ERC223 Interface logic based on ERC20, backward compatible
 */
contract IERC223 {

    function name() public view returns (string _name);
    function symbol() public view returns (string _symbol);
    function decimals() public view returns (uint8 _decimals);


    function transfer(address to, uint value) public returns (bool ok);
    function transfer(address to, uint value, bytes data) public returns (bool ok);
    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool ok);


    function totalSupply() public view returns (uint256);
    
    function balanceOf(address who) public view returns (uint256);
    
    function allowance(address owner, address spender)
        public view returns (uint256);


    function approve(address spender, uint256 value)
        public returns (bool);
    
    function transferFrom(address from, address to, uint256 value)
        public returns (bool);
    
    event TransferData(address indexed from, address indexed to, uint value, bytes indexed data);
    
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 value
    );
}