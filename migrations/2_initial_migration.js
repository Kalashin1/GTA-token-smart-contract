const Trixswap = artifacts.require("Trixswap");

module.exports = function (deployer) {
  const totalSupply = Math.floor(100000000 * 18)
  deployer.deploy(Trixswap, totalSupply);
};
