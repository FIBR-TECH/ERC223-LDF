
pragma solidity ^0.4.9;

/**
 * @title IReceiver
 * @dev Interface for contract wanting to implement the ERC223 fallback
 * 
 **/
 
interface IReceiver {
    function tokenFallback(address _from, uint _value, bytes _data) external payable;
}