Open Issues
===========

This document is meant to be a running issue-list of things that need to be
understood and/or decided as part of the Zydeco token sale.

Mechanics of the Sale
---------------------

Perhaps most importantly, the mechanics of the crowd-sale need to be
decided. There are several ways of doing this.

Totally Out-of-Band
...................

In an out-of-band sale, APL would collects funds for initial investors on
a website -- either ours or some funding portal -- and then do the conversion
later. So, in general terms:

1. APL puts up a website or finds a portal and collects funds.

1. After the sale is over, the funds are examined and tokens are
   minted/distributed to investors.

This is probably a non-starter, but it does have some....

**Advantages**:

* Funds are collected in dollars, so there is no liability to APL
  or the investor owing to the volatility of ether.
* Funds are collected in dollars, so APL/Geosellar may more easily
  access them for the deployment of solar.

There are also ...

**Disadvantages**:

* Funds are collected in dollars, so the investors may not even know what
  an ether *is*, and this would ultimately be a total cluster f**k.

Work that would need to be performed:

* A portal would need to be identified, or
* A web page would need to be created to accept the payments and record
  information.
* Token creation code (which would probably be ``node.js`` with ``web3``)
  would need to be created.

Just Collecting Ether
.....................

We could also just publish an account or wallet address and have investors
send ether to that address.

1. Publish an address. This would probably be a wallet, as opposed to a
   straight account (as I believe it is easier to track incoming transactions
   in a wallet).
1. Collect ether funds.
1. At the culmination of the sale the transactions would be examined and
   tokens would be created and distributed to the investors.

If we were to go this route we would probably want to write a little code that
acted as a counter so people could see the progress of the sale as it was
going on (probably via `web3 <https://github.com/ethereum/web3.js/>`__).

**Advantages**:

* Pretty simple to set up.

**Disadvantage**:

* Not particularly transparent, which could turn some investors off.
* Need to convert the funds to coins at the end, so we would be exposing
  our investors to ether volatility during the campaign.
* Totally confuse a lot of investors.

Work that would need to be performed:

* An account or wallet would need to created.
* A website would need to be put up.
* Token creation code (which would probably be ``node.js`` with ``web3``)
  would need to be created.

Payment to a Smart Contract
...........................

We could create a smart contract that took care of the specifics of the sale.

1. A smart contract for the sale would be created.
1. Funds would be collected in ether.
1. At the end of the sale tokens would be released.

**Advantages**:

* Automated and transparent.
* Could protect investors against ether volatility by calculating their
  share using up-to-date-ish pricing data from an oracle (probably day old
  data).
* Could also do a mass conversion at the end.

**Disadvantages**:

* In its most transparent version, we would need to have the token contract
  locked down at the beginning of the sale so we could automate it fully.

Work that needs to be done:

* Write the contract (not too difficult).
* Decide if the conversions take place daily or at the end.
* If the conversions take place at the end ``node.js`` code will probably
  need to be written to process the token issuance.

In general, in my (mcw) opinion, some variation of this is probably
the best alternative.

Ownership of the Contract
-------------------------

We need to decide who owns the contract. There are two alternatives.

An Account
..........

The contract could be owned by an account. This is simple, but it puts a whole
bunch of eggs in one basket. Whoever has the password to that account could
do anything.

A Wallet
........

The contract could also be owned by a wallet (smart contract). This has the
advantage of being able to set it up as a multiple-signature wallet, which is
a wallet that requires ``N`` signatures to withdraw more than ``X`` ether per day, where
``N`` and ``X`` are configured at the time the deployment of the wallet.

We would have to:

* Decide what limit (if any) to impose upon ether withdrawals.
* Decide how many signatures would be needed.
* Decide who has a valid signature for the wallet.
* Create the accounts and wallet.

APL/Geostellar
--------------

APL and/or Geostellar *still* don't have a way of converting ether to
dollars (i.e., they have no brokerage account.)
