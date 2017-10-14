/**
 * Geostellar, Inc.
 * All rights reserved.
 */
pragma solidity ^0.4.13;

import {Bounty, Target} from "zeppelin-solidity/contracts/Bounty.sol";
import "./Zydeco.sol";

contract ZydecoBounty is Bounty  {

  address public owner;

  function ZydecoBounty () {
    owner = msg.sender;
  }

  function deployContract() internal returns(address) {
    Zydeco zyd = new Zydeco();
    zyd.transferOwnership(owner);
    return zyd;
  }

}
