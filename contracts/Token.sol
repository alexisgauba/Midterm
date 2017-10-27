pragma solidity ^0.4.15;

import './interfaces/ERC20Interface.sol';
import './utils/Math.sol';
import './utils/SafeMath.sol';

/**
 * @title Token
 * @dev Contract that implements ERC20 token standard
 * Is deployed by `Crowdsale.sol`, keeps track of balances, etc.
 */

contract Token is ERC20Interface {

	// total amount of tokens 
	uint256 public totalSupply; 
	uint256 constant MAX_UINT256 = 2**256 - 1;
	mapping (address => uint256) balances; 
	mapping (address => mapping (address => uint256)) allowed; 

	event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    event Burn(address indexed burner, uint256 value);

    ///Constructs the token 
    function Token(uint _totalSupply){
    	totalSupply = _totalSupply;
    }

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public constant returns (uint256 balance){
    	return balances[_owner];
    }

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint256 _value) public returns (bool success){
    	if (balances[msg.sender] >= _value){
    		return true;
    	}
    	balances[msg.sender] -= _value; 
    	balances[_to] += _value;
    	Transfer(msg.sender, _to, _value);
    	return true; 
    }

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success){
    	uint256 allowance = allowed[_from][msg.sender];
    	if(balances[_from] >= _value && allowance >= _value){
    		return true;
    	}
    	balances[_to] += _value; 
    	balances[_from] -= _value; 
    	if (allowance < MAX_UINT256){
    		allowed[_from][msg.sender] -= _value; 
    	}
    	Transfer(_from, _to, _value);
    	return true; 
    }

    /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of tokens to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint256 _value) public returns (bool success){
    	allowed[msg.sender][_spender] = _value; 
    	Approval(msg.sender, _spender, _value);
    	return true;
    }

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining){
    	return allowed[_owner][_spender];
    }

    /**
     * @dev Burns a specified amount of tokens.
     * @param _value The amount of tokens to burn. 
     */
    function burn(uint256 _value) {
        address burner = msg.sender;
        balances[burner] -= _value;
        totalSupply -= _value;
        Burn(msg.sender, _value);
    }
}

