The Coin of the Realm
=====================

The new ``Zydeco`` token, re-factored to make use of
`Open Zeppelin <https://github.com/OpenZeppelin/zeppelin-solidity>`_.

Currently Implemented Functionality
-----------------------------------

The token currently supports the `ERC20 Token standard <https://github.com/ethereum/EIPs/issues/20>`__,
to wit:

``totalSupply``
...............

The total supply of the token.

.. code:: javascript

    function totalSupply() constant returns (uint256 totalSupply)

``balanceOf``
.............

The balance of an account.

.. code:: javascript

    function balanceOf(address _owner) constant returns (uint256 balance)

``transfer``
............

Allows tokens to be transfered.

.. code:: javascript

    function transfer(address _to, uint256 _value) returns (bool success)

``transferFrom``
................

Allows third-party transfers. Note that third-party transfers must be approved
via the ``approve()`` function (see below).

.. code:: javascript

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success)


``approve``
...........

Approve a third-party transfer.

.. code:: javascript

    function approve(address _spender, uint256 _value) returns (bool success)


Events Emitted
--------------

=========== ==================================================================================
Event       Signature
=========== ==================================================================================
Transfer    event Transfer(address indexed _from, address indexed _to, uint256 _value
Approval    event Approval(address indexed _owner, address indexed _spender, uint256 _value)
=========== ==================================================================================

The Bug Bounty
--------------

This repository also contains a contract, ``ZydecoBounty``, which can be used for a bug
bounty.

To use it, one would first deploy it to the ether foundation network, and then send
an ether reward to it. Researchers can then spawn a target contract and try to compromise it.
If they do compromise it, then can claim the reward that has been affixed. In truffle/psuedocode:

.. code:: javascript

  let target = await bounty.createTarget({from:researcher}); // creates a target
  // research tries to break it. bounty is bounty contract
  await bounty.claim(targetAddress, {from:researcher});      // claims reward
  await bounty.withdrawPayments({from:researcher});          // Withdraws award

The way compromise is detected is via a function, `checkInvariant()`. Currently:

.. code::

  function checkInvariant() returns(bool) {
    // Check the compromised flag.
    if (compromised == true) {
      return false;
    }
    return true;
  }

  function compromiseContract() onlyOwner {
      compromised = true;
  }

Our invariant checks a flag called ``compromised``, which can only be
set by the owner. So this tests if the ownership of the contract was
somehow compromised. As the contract is fleshed out, we can add other
checks to this function.

For more information, see the Open Zeppelin `blog entry <https://blog.zeppelin.solutions/setting-up-a-bug-bounty-smart-contract-with-openzeppelin-a0e56434ad0e>`__ on the
subject.

Development
-----------

Running the tests is straight-forward:

* run ``testrpc`` in a terminal
* run ``truffle test`` in another terminal

Unfortunately, using Open Zeppelin complicates deploying to other networks.
See the `development notes <documentation>`__ for details.

Notes on the basic functioning of the token are `here
<documentation/basic_function>`__.
