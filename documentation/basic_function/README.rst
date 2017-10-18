Basic Zydeco Function
=====================

*(Chis, feel free to create a wiki and move this to that as you
see fit.)*

**Important Note**: There are some slight differences in what is described here
and what was discussed on the call. On closer inspection, a few of the ideas
discussed don't work. I'll try to point those out as they arise.

Tradeability
------------

An important attribute of the Zydeco token is that it can be exchange-traded.
This imposes two constraints:

* The token must implement the `ERC20 standard
  <https://theethereum.wiki/w/index.php/ERC20_Token_Standard>`__.
* All Zydeco tokens must be identical (which in practice means that there should
  be no ledger entries that cause differences in valuations of tokens owned by
  different addresses).

On the first point, though, note that by sub-classing Open Zeppelin's ``StandardToken``,
we have implemented a super-set of ERC20: the ``StandardToken`` includes
functions to increase and decrease the allowance of third-party transfers.

Token Operation
---------------

To illustrate the function of the token, some typical token life-cycles will be
illustrative.

1: Birth -- Buy Some Tokens
...........................

Alice decides that she wants to make an investment in Zydeco tokens, so she
buys 1000 of them at the initial offering.

The capital raised from the sale of these tokens (and others in the offering)
is used to deploy solar systems. These systems begin generating revenue.

At periodic intervals payments are made to the token holders. These take the
form of ethereum payments made to the Zydeco contract. A token-holder's portion is
related to the percentage of the outstanding tokens in the contract. To
illustrate this, imagine that:

* 2000 tokens are sold; Alice owns 1000 of them
* The solar systems generate revenue, and after fees $100.00 is available
  to the investors
* That $100.00 is converted to ether, which at the time of the conversion
  amounts to 1 ether.
* The 1 ether from above is deposited to the Zydeo contract.
* Alice's share of the kitty is this 0.5 ether, as she owns 1/2 the tokens.

These payments are made on a scheduled period.

(Note: the specifics of how the tokens will be bought and sold initially is
being research by Beau.)

2: Flying the coop -- Trading
.............................

Eventually Alice marries one of the Koch brothers, and he's not too keen
on Alice owning an investment in sustainable energy. So she decides to
trade her token on a public exchange, and she can do this because we've
adhered to the ERC20 standard and a few public exchanges have decided
to traffic in Zydeco. The trade takes place on the exchange.

3: Death -- Cashing Out Tokens
..............................

Brenda, who purchased Alice's tokens, holds on to them for a
while. Eventually her son, Little Willie, grows up and decides to go to
college. She needs money, so she decides to liquidate some of her assets,
and the Zydeco is one of the assets she wants to liquidate.

She has two choices for this. First, she can do the same as Alice and
trade her tokens on an exchange, but if she did that she wouldn't be
demonstrating how tokens are retired. Also, because she own 1/2 the
tokens, she's a bit afraid or adversely affecting the market, so instead
she decides to cash them out.

When a token is cashed out:

* The owner of the token withdraws an amount of ether to which they are entitled.
  At this point -- 10 years later, there are 21 eth in the kitty. Brenda, owning
  half of the tokens can withdraw 10.5 eth.
* The tokens -- in this case 1000 -- are retired.

What does retirement mean?  When a token is cashed out, it is transferred
to the APL account (which is the account that owns the contract). The
tokens still exist, but they are not used in the calculation for
apportioning the dividend payment. In other words, the outstanding 1000
tokens receive all of the dividend payments. Dividend payments continue
to be made, but the pool into which they are divided is now smaller.

(For implementation, we may in fact just delete those tokens by
decreasing ``totalSupply``.)

4: The Karmic Cycle -- Issuing new Tokens
.........................................

**Here is a difference from the original discussion.**

There is really no way of issuing tokens into the same pool. The problem
lies in the fact that to issue a token and have it equivalent to the
outstanding tokens, we would need to pay into the contract an amount
of ether equivalent to the amount that has accrued.  So if we wanted to
issue another 1000 tokens to raise money to build more systems, we would
have to pay 21 ether into the contract, which is actually more expensive
than the face value of the token; we would lose money when we did this.

Therefor, in this scheme, there could be no further issuance. If
we wanted to raise more money, we would have to issue tokens from a
new contract. Thus -- if it should ever be necessary to do this --
the ``public name`` of the token should probably include versioning
information, i.e.:

.. code:: javascript

  string public constant name     = "ZydecoV1";
  string public constant symbol   = "ZYD";

5: The Eschaton -- Nothing Remaining
....................................

30 years after the ICO the systems are no longer in operation, so no
payment will ever be made to the contract. At this point the value of
the token has converged to the value of the ether that has been paid
into the contract over its life. While they could still be traded, it
really doesn't make sense that they be, so holders will at that point
cash out their positions.

Interestingly, the accrued ether is kind of an "alternative compliance
payment," in that it sets a lower limit of the value of the token. A
Zydeco will be worth at *least* the amount of the accrued ether, and
early on the value will be substantially higher than this, as the value
is based on future predicted cash-flows. Towards the end of the contract
the value will be almost entirely determined by the accrued ether. Thus
this is an investment which *decreases* in risk as time goes on. This
may be an attractive feature for some investors.

Alternatives
------------

It would be nice if we could figure out a way of issuing new tokens
and deploying new systems. That was we could continue to raise money
and continue to deploy systems without doing another ICO. This has the
additional benefit of keeping the tokens from expiring after 30 years.

If anyone can figure it out, this would be a really good thing.
