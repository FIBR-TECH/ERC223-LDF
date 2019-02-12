var LDFToken = artifacts.require("./LDFToken.sol");

module.exports = function(deployer) {
    //const userAddress = accounts[1];
    deployer.deploy(LDFToken);
};
