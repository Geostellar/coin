/**
 * Geostellar, Inc.
 * All rights reserved.
 */
pragma solidity ^0.4.13;

import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import {Bounty, Target} from "zeppelin-solidity/contracts/Bounty.sol";

contract Zydeco is Ownable, Target, StandardToken {
    using SafeMath for uint256;

    /** public data from our other classes:
    *   address public owner;       // from Ownable
    *   uint256 public totalSupply; // from ERC20Basic
    */

    // Expected of ERC20
    string public constant name     = "ZydecoTestV0";
    string public constant symbol   = "ZYDECOV0";
    uint8  public constant decimals = 18;

    bool public compromised; // In testing, true means the contract was breached


    function Zydeco () {
      compromised = false;
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
