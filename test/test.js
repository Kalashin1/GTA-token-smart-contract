var GTAGAMING = artifacts.require('./GTAGAMING.sol');
var BigNumber = require('big-number');

contract('GTAGAMING', async (accounts) => {

  // it('sets the total supply upon deployment', async () => {
  //   const GTAGAMINGInstace = await GTAGAMING.deployed();
  //   const totalSupply = await GTAGAMINGInstace.totalSupply();
  //   assert.equal(totalSupply.toString(), 1000000000000000000000000 , 'sets the totalSupply to 1,000,000');
  // })

  it('sets the name and symbol upon deployment', async () => {
    const GTAGAMINGInstace = await GTAGAMING.deployed();
    const name = await GTAGAMINGInstace.name();
    const symbol = await GTAGAMINGInstace.symbol();
    assert.equal(name, "grandtheftgaming", 'sets the name to be set');
    assert.equal(symbol, "GTA", 'sets the symbol to be TXSW');
  })

  it("reads the balance of a user", async () => {
    const GTAGAMINGInstace = await GTAGAMING.deployed();
    const bal = await GTAGAMINGInstace.balanceOf(accounts[0]);
    assert.equal(bal, 600000000 * Math.pow(10, 18));
  })

  it('should stake some tokens', async () => {
    const GTAGAMINGInstace = await GTAGAMING.deployed();
    const _initialBal = await GTAGAMINGInstace.balanceOf(accounts[0]);

    let initialBal = Number(_initialBal)/Math.pow(10, 18)
    const _stakingAmount = 6000000000000000000000;
    let stakingAmount = _stakingAmount/Math.pow(10, 18)
    
    await GTAGAMINGInstace.stake(accounts[0], "6000000000000000000000");
    const _bal = await GTAGAMINGInstace.balanceOf(accounts[0]);

    let bal = Number(_bal)/Math.pow(10, 18)
    assert.equal(initialBal, bal + stakingAmount)

    const _stakedAmountFromContract = await GTAGAMINGInstace._getTotalStakedAmout(accounts[0]);
    let stakedAmountFromContract = _stakedAmountFromContract/Math.pow(10, 18)
    console.log(stakedAmountFromContract)

    const _initialStakingDateFromContract = await GTAGAMINGInstace._getInitialStakeDate(accounts[0])
    console.log(new Date(Number(_initialStakingDateFromContract) * 1000).toDateString())
  })
  
  // it('should unstake some tokens', async () => {
  //   const GTAGAMINGInstace = await GTAGAMING.deployed();
  //   const _initialBal = await GTAGAMINGInstace.balanceOf(accounts[0]);
  //   let initialBal = Number(_initialBal)/Math.pow(10, 18)
  //   const _stakingAmount = 6000000000000000000000;
  //   let stakingAmount = _stakingAmount/Math.pow(10, 18)
  //   await GTAGAMINGInstace.unstake(accounts[0], "6000000000000000000000");
  //   const _bal = await GTAGAMINGInstace.balanceOf(accounts[0]);
  //   let bal = Number(_bal)/Math.pow(10, 18)
  //   // console.table({ initialBal, bal, stakingAmount })
  //   assert.equal(initialBal, bal - stakingAmount)
  // })

  it("should calculate rewards", async () => {
    const GTAGAMINGInstace = await GTAGAMING.deployed();
    const _stakingAmount = 6000000000000000000000;
    let stakingAmount = _stakingAmount/Math.pow(10, 18)
    await GTAGAMINGInstace.stake(accounts[0], "6000000000000000000000");
    const _reward = await GTAGAMINGInstace.showReward(accounts[0]);
    console.log(_reward/Math.pow(10, 18))
  })

  it("should return the ether balance", async () => {
    const GTAGAMINGInstace = await GTAGAMING.deployed();
    const _etherBal = await GTAGAMINGInstace.getBalance();
    const addr = await GTAGAMINGInstace._address();
    await GTAGAMINGInstace.receive(10);
    console.log(_etherBal/Math.pow(10, 18), addr)
  })
})