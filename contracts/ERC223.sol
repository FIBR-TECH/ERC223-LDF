
pragma solidity ^0.4.24;

import "./IReceiver.sol";
import "./IERC223.sol";
import "./SafeMath.sol";
import "./IHolder.sol";
import "./Ownable.sol";

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
contract ERC223 is Ownable{
    using SafeMath for uint256;
    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowed;
    
    uint256 private _totalSupply;

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
    
    /**
    * @dev Function to access total supply of tokens 
    * @return A uint256 specifying the total amount of coins in circulation.
    */
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }
    
    /**
    * @dev Function to return a balance of the address.
    * @return A uint256 specifying the amount of tokens by the spender.
    */
    function balanceOf(address owner) public view returns (uint256) {
        return _balances[owner];
    }
  
    /**
    * @dev Function to check the amount of tokens that an owner allowed to a spender.
    * @param owner address The address which owns the funds.
    * @param spender address The address which will spend the funds.
    * @return A uint256 specifying the amount of tokens still available for the spender.
    */
    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowed[owner][spender];
    }

    /**
    * @dev Transfer tokens from one address to another
    * @param from address The address which you want to send tokens from
    * @param to address The address which you want to transfer to
    * @param value uint256 the amount of tokens to be transferred
    */
    function transferFrom(address from, address to, uint256 value) public returns (bool){
        bytes memory empty;
        bool answer;
        if(_isContract(to)) {
            answer = _transferToContract(from, to, value, empty);
            _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        }
        else {
            answer = _transferToAddress(from, to, value, empty);
            _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
        }
        return answer;
    }

    /**
    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
    * Beware that changing an allowance with this method brings the risk that someone may use both the old
    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
    * @param spender The address which will spend the funds.
    * @param value The amount of tokens to be spent.
    */
    function approve(address spender, uint256 value) public returns (bool) {
        require (spender != address(0), "[Approve Error] Spender account cannot be 0x address");

        _allowed[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
        return true;
    }

    /**
    * @dev Increase the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[_spender] == 0. To increment
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * From MonolithDAO Token.sol
    * @param spender The address which will spend the funds.
    * @param addedValue The amount of tokens to increase the allowance by.
    */
    function increaseAllowance(address spender, uint256 addedValue) public returns (bool){
        require (spender != address(0), "[Allowance Error] Spender account cannot be 0x address");

        _allowed[msg.sender][spender] = (_allowed[msg.sender][spender].add(addedValue));

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Decrease the amount of tokens that an owner allowed to a spender.
    * approve should be called when allowed_[spender] == 0. To decrement
    * allowed value is better to use this function to avoid 2 calls (and wait until
    * the first transaction is mined)
    * From MonolithDAO Token.sol
    * @param spender The address which will spend the funds.
    * @param subtractedValue The amount of tokens to decrease the allowance by.
    */
    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool){
        _allowed[msg.sender][spender] = (
        _allowed[msg.sender][spender].sub(subtractedValue));

        emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
        return true;
    }

    /**
    * @dev Public function that allows to transfer tokens with additional data 
    * and customized fallback.
    * @param to Address of the recepient of the tokens.
    * @param value The amount of the tokens to be transfered.
    * @param data Additional data to be send to the recepient.
    * @param custom_fallback Customized fallback that is executed after the transfer of the tokens.
    * @return A bool defining if the transfer was succesful.
    */
    function transfer(address to, uint value, bytes data, string custom_fallback) public returns (bool success) {
        if(_isContract(to)) {
            require (balanceOf(msg.sender) > value, "[Transfer Error] Balance must be greater then amount to be transfered");
            _balances[msg.sender] = balanceOf(msg.sender).sub(value);
            _balances[to] = balanceOf(to).add(value);
            assert(to.call.value(0)(bytes4(keccak256(abi.encodePacked(custom_fallback))), msg.sender, value, data));
            emit TransferData(msg.sender, to, value, data);
            return true;
        }
        else {
            return _transferToAddress(msg.sender, to, value, data);
        }
    }

    /**
    * @dev Public function that allows to transfer tokens with additional data. 
    * Function implements recognition if the recepeient is a contract or not and executes different subfunctions.
    * @param to Address of the recepient of the tokens.
    * @param value The amount of the tokens to be transfered.
    * @param data Additional data to be send to the recepient.
    * @return A bool defining if the transfer was succesful.
    */
    function transfer(address to, uint value, bytes data) public returns (bool success) {
        if(_isContract(to)) {
            return _transferToContract(msg.sender, to, value, data);
        }
        else {
            return _transferToAddress(msg.sender, to, value, data);
        }
    }
  
    /**
    * @dev Public function that allows to transfer tokens.
    * Function implements recognition if the recepeient is a contract or not and executes different subfunctions.
    * @param to Address of the recepient of the tokens.
    * @param value The amount of the tokens to be transfered.
    * @return A bool defining if the transfer was succesful.
    */
    function transfer(address to, uint value) public returns (bool success) {
        bytes memory empty;
        if(_isContract(to)) {
            return _transferToContract(msg.sender, to, value, empty);
        }
        else {
            return _transferToAddress(msg.sender, to, value, empty);
        }
    }

    /**
    * @dev Internal function that mints an amount of the token and assigns it to
    * an account. This encapsulates the modification of balances such that the
    * proper events are emitted.
    * @param account The account that will receive the created tokens.
    * @param value The amount that will be created.
    */
    function _mint(address account, uint256 value) internal onlyOwner {
        require (account != address(0), "[Mint Error] Recipient of tokens cannot be address 0");

        _totalSupply = _totalSupply.add(value);
        _balances[account] = _balances[account].add(value);
        emit Transfer(address(0), account, value);
    }

    /**
    * @dev Internal function that burns an amount of the token of a given
    * account.
    * @param account The account whose tokens will be burnt.
    * @param value The amount that will be burnt.
    */
    function _burn(address account, uint256 value) internal {
        _totalSupply = _totalSupply.sub(value);
        _balances[account] = _balances[account].sub(value);
        emit Transfer(account, address(0), value);
    }

    /**
    * @dev Internal function that burns an amount of the token of a given
    * account, deducting from the sender's allowance for said account. Uses the
    * internal burn function.
    * @param account The account whose tokens will be burnt.
    * @param value The amount that will be burnt.
    */
    function _burnFrom(address account, uint256 value) internal onlyOwner{
        // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
        // this function needs to emit an event with the updated approval.
        _burn(account, value);
        emit Approval(account, msg.sender, _allowed[account][msg.sender]);
    }

    /**
    * @dev Private function that recognizes if an address is a contract.
    * The function checks it based on external code size.
    * @param _addr Address to be checked.
    * @return A bool defining if the address is a contract.
    */
    function _isContract(address _addr) private view returns (bool is_contract) {
        uint length;
        assembly {
                length := extcodesize(_addr)
        }
        return (length>0);
    }

    /**
    * @dev Private function that transfers changes the balance of the private address 
    * according to the transfer parameters.
    * @param _to Address of the recepient of the tokens.
    * @param _value The amount of the tokens to be transfered.
    * @param _data Additional data to be emited.
    * @return A bool defining if the transfer was succesful.
    */
    function _transferToAddress(address _from, address _to, uint _value, bytes _data) private returns (bool success) {
        require (balanceOf(_from) > _value, "[Transfer Error] Balance must be greater then amount to be transfered");
        require (_to != address(0), "[Transfer Error] _to cannot be 0x address");

        _balances[_from] = balanceOf(_from).sub(_value);
        _balances[_to] = balanceOf(_to).add(_value);

        emit Transfer(_from, _to, _value);
        emit TransferData(_from, _to, _value, _data);
        return true;
    }
  
    /**
    * @dev Private function that transfers changes the balance of the contract address 
    * according to the transfer parameters. Additionally it executes fallback in the contract.
    * @param _to Address of the recepient of the tokens.
    * @param _value The amount of the tokens to be transfered.
    * @param _data Additional data to be send to the recepient and emited.
    * @return A bool defining if the transfer was succesful.
    */
    function _transferToContract(address _from, address _to, uint _value, bytes _data) private returns (bool success) {
        require (balanceOf(_from) > _value, "[Transfer Error] Balance must be greater then amount to be transfered");
        require (_to != address(0), "[Transfer Error] _to cannot be 0x address");

        _balances[_from] = balanceOf(_from).sub(_value);
        _balances[_to] = balanceOf(_to).add(_value);
        IReceiver(_to).tokenFallback(_from, _value, _data);
        
        emit Transfer(_from, _to, _value);
        emit TransferData(_from, _to, _value, _data);
        return true;
    }
    
    /**
        @dev withdraw tokens from the contract. Function can only be called by a contract which holds the money.
        @param _from  address that executed the contract
        @param _value amount of tokens to withdraw
    */
    function withdraw(address _from, uint256 _value)
        public
    {
        require (balanceOf(msg.sender) >= _value, "Balance must be greater then amount to be transfered");
        require(IHolder(msg.sender).isWithdrawable() == true, "contract is not withrdrawable");
         _balances[_from] = _balances[_from].add(_value); 
         _balances[msg.sender] = _balances[msg.sender].sub(_value);
        emit Transfer(msg.sender, _from, _value);
    }
    
    
}