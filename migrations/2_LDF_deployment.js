var LDFToken = artifacts.require("./LDFToken.sol");
var LDFToken = artifacts.require("./Test.sol");

module.exports = function(deployer) {
    //const userAddress = accounts[1];
    deployer.deploy(LDFToken);
    deployer.deploy(Test);
};
