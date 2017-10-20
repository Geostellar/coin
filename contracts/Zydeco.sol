/**
 * Geostellar, Inc.
 * All rights reserved.
 */
pragma solidity ^0.4.13;

import "./Dividend.sol";
import 'zeppelin-solidity/contracts/ownership/Ownable.sol';
import 'zeppelin-solidity/contracts/token/ERC20.sol';
import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/math/SafeMath.sol';
import {Bounty, Target} from "zeppelin-solidity/contracts/Bounty.sol";

contract Zydeco is Ownable, Target, StandardToken, Dividend {
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

    /**
     * @dev Function to check if the contract has been compromised.
     */

    function checkInvariant() returns(bool) {
      // Check the compromised flag.
      if (compromised == true) {
        return false;
      }
      return true;
    }

    /**
    * @dev Add tokens to an account, and increase total supply. Mostly for testing
    * @param _to The address of the recipient
    * @param _value The value to transfer
    */
    function mintTokens(address _to, uint256 _value) onlyOwner returns (bool){
        totalSupply += _value;
        balances[_to] += _value;
        Transfer(0x0, _to, _value);
        return true;
    }

    /**
    * @dev Toggle the compromised flag. For testing the bounty program
    */
    function compromiseContract() onlyOwner {
        compromised = true;
    }
}
