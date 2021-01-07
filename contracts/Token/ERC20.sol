// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

/**
 * file - Token.sol
 * name - name of the token 
 * symbol - symbol of the token
 * decimals - number of significant decimals for the token (18) 
 * totalSupply - total supply of token (interface)
 * balanceOf - Mapping to store number of tokens inside each address
 * allowance - Mapping to store allowance of token transfer for each address
 * 
 */

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./TokenInterface.sol";

contract ERC20 is TokenInterface{
	using SafeMath for uint256;

	uint256 private constant MAX_UINT256 = 2**256 - 1;
    mapping(address => uint256) public balances;
    mapping(address => mapping(address => uint256)) public allowed;

    string public name;
    uint8 public decimals;
    string public symbol;

    constructor(uint256 _initialAmount,
                string memory _tokenName,
                uint8 _decimalUnits,
                string memory _tokenSymbol) public{
                    balances[msg.sender] = _initialAmount;
                    totalSupply = _initialAmount;
                    name = _tokenName;
                    decimals = _decimalUnits;
                    symbol = _tokenSymbol;
                }

    function transfer(address _to, uint256 _value)
        public override returns (bool success) {
            require(balances[msg.sender] >= _value, "Insufficient Balance");
            balances[msg.sender] -= _value;
            balances[_to] += _value;
            emit Transfer(msg.sender, _to, _value);
            return true;
        }

    function transferFrom(address _from, address _to, uint256 _value)public override returns (bool success){
        uint256 allowance = allowed[_from][msg.sender];
        require(balances[_from] >= _value && allowance >= _value,"Insufficient Balance");

        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        
        if (allowance < MAX_UINT256) {
            allowed[_from][msg.sender] -= _value;
        }

        emit Transfer(_from, _to, _value); 
        return true;
    }

    function balanceOf(address _owner) public view override returns (uint256 balance){
            return balances[_owner];
        }

    function approve(address _spender, uint256 _value)public override returns (bool success){
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value); 
        return true;
    }

    function allowance(address _owner, address _spender) public view override returns (uint256 remaining){
        return allowed[_owner][_spender];
    }

}