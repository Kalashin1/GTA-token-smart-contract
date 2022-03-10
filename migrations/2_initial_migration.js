const GTAGAMING = artifacts.require("GTAGAMING");

module.exports = async function (deployer) {
  deployer.deploy(GTAGAMING);
};
