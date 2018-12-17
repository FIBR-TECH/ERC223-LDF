pragma solidity ^0.4.24;

import "./IReceiver.sol";
    
contract Crowdfunding is IReceiver {
    
    event tokensReceived(address, uint, bytes);

    /**
     * @dev called on tokenFallback, registers the investment, and mints the LCT to the investor if the amount invested does not cause the loan to be over funded
     * @param _value the amount of token received by the contract
     * @param _from the address of the investor
     * @param _data extra data send with transaction
     */
    function tokenFallback(address _from, uint _value, bytes _data) external payable{
        emit tokensReceived(_from, _value, _data);
    }
}