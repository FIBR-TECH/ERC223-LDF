pragma solidity ^0.4.24;

/* New Holder contract interface */

interface IHolder  {


    /**
     * Gets status of the contract holding Tokens
     */
    function getStatus() external view returns(uint);
   
   
     /**
     * Gets owner of Holder contract
     */ 
    function owner() public view returns (address);
    
}