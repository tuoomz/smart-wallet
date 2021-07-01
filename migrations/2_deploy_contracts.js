var dBank = artifacts.require("./dBank.sol");
var token = artifacts.require("./Token.sol");

module.exports = async function(deployer) {
  await deployer.deploy(token)
  await deployer.deploy(dBank, token.address);
};
