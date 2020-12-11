const TheProduct = artifacts.require("TheProduct");

module.exports = function(deployer) {
  deployer.deploy(TheProduct);
};