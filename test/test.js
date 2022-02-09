var Trixswap = artifacts.require('./Trixswap.sol');

contract('Trixswap', async (accounts) => {

  it('sets the total supply upon deployment', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const totalSupply = await trixswapInstace.totalSupply();
    assert.equal(totalSupply.toNumber(), (100000000 * 18) , 'sets the totalSupply to 1,000,000');
  })

  it('sets the name and symbol upon deployment', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const name = await trixswapInstace.name();
    const symbol = await trixswapInstace.symbol();
    assert.equal(name, "Trixswap", 'sets the name to be set');
    assert.equal(symbol, "TXSW", 'sets the symbol to be TXSW');
  })

  it('Read a balance', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const balance = await trixswapInstace.balanceOf(accounts[0]);
    console.log(balance.toNumber())
    assert.equal(balance.toNumber(), (100000000 * 18), 'read the admin balance');
  })

  it('Mint Some new Tokens', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const mintingStatus = await trixswapInstace.mint(1000);
    console.log(mintingStatus)
    // assert.equal(mintingStatus, true, 'should mine some new tokens');
    const balance = await trixswapInstace.balanceOf(accounts[0]);
    console.log(balance.toNumber())
    assert.equal(balance.toNumber(), ((100000000 * 18) + 1000), 'read the admin balance');
  })

  it('Transfer some tokens', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const mintingStatus = await trixswapInstace.transfer(accounts[1],10000);
    // assert.equal(mintingStatus, true, 'should mine some new tokens');
    const balance = await trixswapInstace.balanceOf(accounts[1]);
    console.log(balance.toNumber())
    assert.equal(balance.toNumber(), 10000, 'read the new balance');
  })

  it('Should stake some tokens', async () => {
    const trixswapInstace = await Trixswap.deployed();
    let initialBal = await trixswapInstace.balanceOf(accounts[0])
    initialBal = initialBal.toNumber();
    const amountToStake = 2000;
    await trixswapInstace.stake(amountToStake);
    let balAfterStaking = await trixswapInstace.balanceOf(accounts[0]);
    balAfterStaking = balAfterStaking.toNumber()
    assert.equal(
      balAfterStaking + amountToStake, 
      initialBal, 
      `expected ${balAfterStaking + amountToStake} to be equal to ${initialBal}`
    )
    let hasStaked = await trixswapInstace.hasStaked(accounts[0]);
    assert(hasStaked, true, "has staked should be true");
  })

  it("checks if the user has staked before", async () => {
    const trixswapInstace = await Trixswap.deployed();
    let hasStaked = await trixswapInstace.hasStaked(accounts[0]);
    assert(hasStaked, false, "has staked should be false");
  })

  it('Should unstake some tokens', async () => {
    const trixswapInstace = await Trixswap.deployed();
    let initialBal = await trixswapInstace.balanceOf(accounts[0])
    initialBal = initialBal.toNumber();
    const amountToStake = 2000;
    await trixswapInstace.stake(amountToStake);
    let balAfterStaking = await trixswapInstace.balanceOf(accounts[0]);
    balAfterStaking = balAfterStaking.toNumber()

    assert.equal(
      balAfterStaking + amountToStake, 
      initialBal, 
      `expected ${balAfterStaking + amountToStake} to be equal to ${initialBal}`
    )
    let hasStaked = await trixswapInstace.hasStaked(accounts[0]);
    assert(hasStaked, true, "has staked should be true");

    await trixswapInstace.unstake(amountToStake);
    const balAfterUnstaking = await trixswapInstace.balanceOf(accounts[0]);
    assert.equal(
      balAfterStaking + amountToStake, 
      initialBal, 
      `expected ${balAfterUnstaking} to be equal to ${initialBal}`
    )
  })


})