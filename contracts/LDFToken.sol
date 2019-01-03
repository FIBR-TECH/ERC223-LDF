pragma solidity ^0.4.24;

import "./ERC223.sol";
import "./ERC223Detailed.sol";
import "./ERC223Mintable.sol";
import "./ERC223Burnable.sol";

/**
 * @title ERC223 Token
 *
 * @dev Lendflo implementation of ERC223 Token originally suggested by: 
 * https://github.com/Dexaran/ERC223-token-standard
 * and strongly based on standard ERC20 Token:
 * https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/ERC20.sol
 * Lendflo ERC223 implements light fallback function that is not pure
 * and therefore allows to execute other functions in the contract after the transfer of funds.
 */
contract LDFToken is ERC223, ERC223Detailed, ERC223Mintable, ERC223Burnable {
    constructor () public ERC223Detailed("Lendflo Digital Fiat", "LDF", 0) {
    }

}