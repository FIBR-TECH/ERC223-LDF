pragma solidity ^0.4.24;


contract Test {

    enum LCTStatues { Locked, Withdrawable, Repayed}
    LCTStatues status;

    function SimpleEnum() public {
        status = LCTStatues.Locked;
    }

    function setValues(uint _value) public {
        status = LCTStatues(_value);
    }

    function getValue() public constant returns (uint){
        return uint(status);
    }

}