var Zydeco = artifacts.require("./Zydeco.sol");
var ZydecoBounty = artifacts.require("./ZydecoBounty.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(Zydeco);
    deployer.deploy(ZydecoBounty);
};
