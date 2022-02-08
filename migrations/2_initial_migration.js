const Trixswap = artifacts.require("Trixswap");

module.exports = function (deployer) {
  deployer.deploy(Trixswap, 100000000);
};
