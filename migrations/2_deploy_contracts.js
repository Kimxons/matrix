const Product = artifacts.require("Product");
const Registrations = artifacts.require("Registrations");
const ERC20 = artifacts.require("ERC20");

module.exports = function(deployer) {
  deployer.deploy(Product);
  deployer.deploy(Registrations);
  deployer.deploy(ERC20);
};