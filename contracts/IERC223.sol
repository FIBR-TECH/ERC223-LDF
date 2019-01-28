pragma solidity ^0.4.24;

/**
 * @title IERC223
 * @dev ERC223 Interface logic based on ERC20, backward compatible
 */
interface IERC223 {

    function name() external view returns (string _name);
    function symbol() external view returns (string _symbol);
    function decimals() external view returns (uint8 _decimals);


    function transfer(address to, uint value) external returns (bool);
    function transfer(address to, uint value, bytes data) public returns (bool);
    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool);


    function totalSupply() external view returns (uint256);
    
    function balanceOf(address who) external view returns (uint256);
    
    function allowance(address owner, address spender) external view returns (uint256);
        


    function approve(address spender, uint256 value) external returns (bool);
    
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    
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