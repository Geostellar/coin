const Zydeco = artifacts.require("./Zydeco.sol"),
ZydecoBounty = artifacts.require("./ZydecoBounty.sol"),
        Web3 = require('web3'),
        web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var accounts = web3.eth.accounts;

// sendReward is used to send a reward to the bounty contract.

let sendReward = function(sender, receiver, value){
  web3.eth.sendTransaction({
    from:sender,
    to:receiver,
    value: value
  });
};

// Recognized options:
//   initialize: If set, intitialized the Zydeco campaign with this many
//               tokens in accounts[0]

async function mockCampaign(options){
    var coin = await Zydeco.new();
    options = options || {};
    // initialize will give a certian number of tokens to the owner, for testing.
    if (options['initialize']) coin.addTokensToAddress(accounts[0], options['initialize'], {from: accounts[0]});
    return coin
};

// Recognized options:
//   reward: If set, intitialized the bounty reward to this number

async function deployBounty(options){
    var bounty = await ZydecoBounty.new();
    var reward;
    let owner = accounts[0];
    options = options || {};
    if (options['reward']) {
      reward =  web3.toWei(options['reward'], 'ether');
    }
    else {
      reward = web3.toWei(1, 'ether');
    }
    sendReward(owner, bounty.address, reward);
    return bounty
};

async function expectInvalidOperation(operation){
    try {
        await operation();
        assert.fail('Expected error is not thrown');
    } catch(error) {
        assert.equal(
            error.toString(),
            "Error: VM Exception while processing transaction: invalid opcode",
            "Expected error is not thrown."
        )
    }
}

module.exports = {
    campaign: mockCampaign,
    expectInvalidOperation: expectInvalidOperation,
    deployBounty: deployBounty
};
