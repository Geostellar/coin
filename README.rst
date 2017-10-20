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

    function totalSupply() constant returns (uint256 totalSupply);

``balanceOf``
.............

The balance of an account.

.. code:: javascript

    function balanceOf(address _owner) constant returns (uint256 balance);

``transfer``
............

Allows tokens to be transfered.

.. code:: javascript

    function transfer(address _to, uint256 _value) returns (bool success);

``transferFrom``
................

Allows third-party transfers. Note that third-party transfers must be approved
via the ``approve()`` function (see below).

.. code:: javascript

    function transferFrom(address _from, address _to, uint256 _value) returns (bool success);


``approve``
...........

Approve a third-party transfer.

.. code:: javascript

    function approve(address _spender, uint256 _value) returns (bool success);

We also have added functions necessary for the operation as a Zydeco coin.

``mintTokens``
..............

.. code:: javascript

  function mintTokens(address _to, uint256 _value) onlyOwner returns (bool);

This function will add tokens to an address, and must be called by the owner. In operation,
this function will be used for populating the accounts. The deployment scenario should look
something like:

* Create the contract
* Hold the sale and find out who wants tokens (this is being addressed currently elsewhere)
* Use ``mintTokens()`` to put the needed tokens into the owner's account.
* Use ``transfer`` to move the tokens from the ower's account into the investor's account.

One could also directly add the tokens to the investor's accounts directly with this
function. The previous way is probably a bit better because this will emit the
industry-standard ``Transfer`` event, which is widely understood. Any event that the
``mintTokens`` function emits will be APL-specific, and thus not as understood.

``compromiseContract``
......................

.. code:: javascript

  function compromiseContract() onlyOwner;

Flag the contract as compromized, triggering a bounty payment. This is only used
in testing.

``payDividend``
...............

.. code:: javascript

  function payDividend (uint256 _period) public payable onlyOwner;

Pay a dividend. The period an integer that defines a period, and should be unique
(in other words, one shouldn't pay two dividends to the same period). Most easily
it should be a sequential counter, where ``period = currentPeriod + 1``

``checkDividend``
.................

.. code:: javascript

  function checkDividend () public constant returns(uint256);

Check the size of the dividend payment that the sender qaulifies for in the
current period.


``withdrawDvidend``
...................

.. code:: javascript

  function withdrawDvidend () public;

The sender withdraws the payment for the current period. Note that we implement
Open Zepplin's ``PullPayment`` interface, so after this function is executed the
investor will still need to execute ``withdrawPayments``.

``withdrawPayments``
....................

.. code:: javascript

  function withdrawPayments() public;

From Open Zeppelin's ``PullPayment`` interface. The sender claims the payments that they
are approved for. (in APL's case they are approved by ``withdrawDvidend``).


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


Further Information
--------------------

Unfortunately, using Open Zeppelin complicates deploying to other networks.
See the `development notes <documentation>`__ for details.

Notes on the basic functioning of the token are `here
<documentation/basic_function>`__.

Open issues can be found `here <documentation/open_issues>`__.
