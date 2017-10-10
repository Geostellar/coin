The Coin of the Realm
=====================

The new ``Zydeco`` token, refactored to make use of
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
