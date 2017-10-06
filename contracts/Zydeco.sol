/**
 * Geostellar, Inc.
 * All rights reserved.
 */
pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20Basic.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';

contract Zydeco is Ownable, ERC20Basic {
    using SafeMath for uint256;

    /** public data from our other classes:
    *   address public owner;       // from Ownable
    *   uint256 public totalSupply; // from ERC20Basic
    */

    mapping(address => uint256) balances; // Zydeco balances

    function Zydeco () {
    }

    /**
    * @dev Add tokens to an account, and increase total supply. Mostly for testing
    * @param _to The address of the recipient
    * @param _value The value to transfer
    */
    function addTokensToAddress(address _to, uint256 _value) onlyOwner returns (bool){
        totalSupply += _value;
        balances[_to] += _value;
    }

    /**
    * @dev transfer token for a specified address. From BasicToken.sol
    * @param _to The address to transfer to.
    * @param _value The amount to be transferred.
    */
    function transfer(address _to, uint256 _value) returns (bool) {
      balances[msg.sender] = balances[msg.sender].sub(_value);
      balances[_to] = balances[_to].add(_value);
      Transfer(msg.sender, _to, _value);
      return true;
    }

    /**
    * @dev Gets the balance of the specified address. From BasicToken.sol
    * @param _owner The address to query the the balance of.
    * @return An uint256 representing the amount owned by the passed address.
    */
    function balanceOf(address _owner) constant returns (uint256 balance) {
      return balances[_owner];
    }
}
