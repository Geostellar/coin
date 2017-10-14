const mock = require('./mocks'),
    Web3 = require('web3'),
    web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545")),
    Zydeco = artifacts.require("./Zydeco.sol");
    ZydecoBounty = artifacts.require("./ZydecoBounty.sol");

function awaitEvent(event, handler) {
  return new Promise((resolve, reject) => {
    function wrappedHandler(...args) {
      Promise.resolve(handler(...args)).then(resolve).catch(reject);
    }
    event.watch(wrappedHandler);
  });
}

contract('Bounty Contract', accounts => {

  it('has a set reward', async function() {
    let options = {
      reward: 1
    };
    let bounty = await mock.deployBounty(options);
    assert.equal(options['reward'], web3.fromWei(web3.eth.getBalance(bounty.address).toNumber(),'ether'));
  });

  it('empties itself when destroyed', async function(){
    let options = {
      reward: 1
    };
    let bounty = await mock.deployBounty(options);

    let reward = web3.toWei(options['reward']);

    assert.equal(reward, web3.eth.getBalance(bounty.address).toNumber());

    await bounty.destroy();
    assert.equal(0, web3.eth.getBalance(bounty.address).toNumber());
  });

  describe('Uncompromised contract', () => {
    it('cannot claim reward', async function(){
      let owner = accounts[0];
      let researcher = accounts[1];
      let options = {
        reward: 1
      };
      let bounty = await mock.deployBounty(options);

      let event = bounty.TargetCreated({});

      let watcher = async (err, result) => {
        event.stopWatching();
        if (err) { throw err; }
        //console.log(result);

        var targetAddress = result.args.createdAddress;

        assert.equal(web3.toWei(options['reward'], 'ether'),
          web3.eth.getBalance(bounty.address).toNumber());

        try {
          await bounty.claim(targetAddress, {from:researcher});
          assert.isTrue(false); // should never reach here
        } catch(error) {
          let reClaimedBounty = await bounty.claimed.call();
          assert.isFalse(reClaimedBounty);

        }
        try {
          await bounty.withdrawPayments({from:researcher});
          assert.isTrue(false); // should never reach here
        } catch (err) {
          assert.equal(web3.toWei(options['reward'], 'ether'),
            web3.eth.getBalance(bounty.address).toNumber());
        }
      };
      // Thebounty target:
      let target = await bounty.createTarget({from:researcher});
      let createdAddress = await target.logs[1].args.createdAddress;
      target =  await Zydeco.at(createdAddress);

      await awaitEvent(event, watcher);
    });

  });

  describe('Compromised contract', () => {
    it('can claim reward', async function(){
      let owner = accounts[0];
      let researcher = accounts[1];
      let options = {
        reward: 1
      };
      let bounty = await mock.deployBounty(options);

      let event = bounty.TargetCreated({});

      let watcher = async (err, result) => {
        event.stopWatching();
        if (err) { throw err; }
        //console.log(result);

        var targetAddress = result.args.createdAddress;

        assert.equal(web3.toWei(options['reward'], 'ether'),
        web3.eth.getBalance(bounty.address).toNumber());
        await bounty.claim(targetAddress, {from:researcher});
        let claim = await bounty.claimed.call();

        assert.isTrue(claim);

        await bounty.withdrawPayments({from:researcher});

        assert.equal(0, web3.eth.getBalance(bounty.address).toNumber());

      };

      let target = await bounty.createTarget({from:researcher});
      let createdAddress = await target.logs[1].args.createdAddress;
      target =  await Zydeco.at(createdAddress);
      await target.compromiseContract();
      await awaitEvent(event, watcher);
    });
  });
});
