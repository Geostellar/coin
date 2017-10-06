const Zydeco = artifacts.require("./Zydeco.sol"),
    Web3 = require('web3'),
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

var accounts = web3.eth.accounts;


async function mockCampaign(options){
    var coin = await Zydeco.new();
    options = options || {};
    // initialize will give a certian number of tokens to the owner, for testing.
    if (options['initialize']) coin.addTokensToAddress(accounts[0], options['initialize'], {from: accounts[0]});
    return coin
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
};
