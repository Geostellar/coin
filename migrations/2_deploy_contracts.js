var Zydeco = artifacts.require("./Zydeco.sol");

module.exports = function(deployer, network, accounts) {
    deployer.deploy(Zydeco);
};
