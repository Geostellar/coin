/**
 * Geostellar, Inc.
 * All rights reserved.
 */
pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import {Bounty, Target} from "zeppelin-solidity/contracts/Bounty.sol";

contract Zydeco is Ownable, ERC20, Target {
    using SafeMath for uint256;

    /** public data from our other classes:
    *   address public owner;       // from Ownable
    *   uint256 public totalSupply; // from ERC20Basic
    */

    mapping(address => uint256) balances; // Zydeco balances
    mapping (address => mapping (address => uint256)) allowed; // From the ERC20 allowances

    bool public compromised; // In testing, true means the contract was breached


    function Zydeco () {
      compromised = false;
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
    /**
     * @dev Transfer tokens from one address to another
     * @param _from address The address which you want to send tokens from
     * @param _to address The address which you want to transfer to
     * @param _value uint256 the amount of tokens to be transferred
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
      require(_to != address(0));

      uint256 _allowance = allowed[_from][msg.sender];

      // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
      // require (_value <= _allowance);

      balances[_from] = balances[_from].sub(_value);
      balances[_to] = balances[_to].add(_value);
      allowed[_from][msg.sender] = _allowance.sub(_value);
      Transfer(_from, _to, _value);
      return true;
    }

    /**
     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
     *
     * Beware that changing an allowance with this method brings the risk that someone may use both the old
     * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
     * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     * @param _spender The address which will spend the funds.
     * @param _value The amount of tokens to be spent.
     */
    function approve(address _spender, uint256 _value) public returns (bool) {
      allowed[msg.sender][_spender] = _value;
      Approval(msg.sender, _spender, _value);
      return true;
    }

    /**
     * @dev Function to check the amount of tokens that an owner allowed to a spender.
     * @param _owner address The address which owns the funds.
     * @param _spender address The address which will spend the funds.
     * @return A uint256 specifying the amount of tokens still available for the spender.
     */
    function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
      return allowed[_owner][_spender];
    }

    // Now we have the Bounty code, as the contract is Bounty.

    function checkInvariant() returns(bool) {
      // Check the compromised flag.
      if (compromised == true) {
        return false;
      }
      return true;
    }

    /**
     * @dev Function to check tIf the contract has been compromised.
     */

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
    * @dev Toggle the compromised flag. For testing the bounty program
    */
    function compromiseContract() onlyOwner {
        compromised = true;
    }
}
