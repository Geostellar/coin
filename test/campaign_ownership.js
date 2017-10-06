const mock = require('./mocks'),
    Web3 = require('web3'),
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545")),
    Zydeco = artifacts.require("./Zydeco.sol");

contract('Owned Zydeco Campaign', accounts => {

    let campaign;
    before(async () => {
         campaign = await mock.campaign();
    });
    it("should have the correct owner", async () => {
        let owner = await campaign.owner.call();
        assert(owner == accounts[0], "Campaign was not created with correct owner");
    });
    it("should allow the ownership to be transfered", async () => {
        await campaign.transferOwnership(accounts[2], {from: accounts[0]});
        let owner = await campaign.owner.call();
        assert(owner == accounts[2], "Campaign ownership was not transfered");
    });
    it("should fail when non-owner attempts ownership transfer", async () => {
        await mock.expectInvalidOperation(async () => {
            await campaign.transferOwnership(accounts[0], {from: accounts[0]});
        });
    });

});
