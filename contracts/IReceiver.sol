pragma solidity ^0.4.24;

 /*
 * Contract that is working with ERC223 tokens
 */
 
interface IReceiver {
    function tokenFallback(address _from, uint _value, bytes _data) external payable;
}