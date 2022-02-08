var Trixswap = artifacts.require('./Trixswap.sol');

contract('Trixswap', async (accounts) => {
  it('sets the total supply upon deployment', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const totalSupply = await trixswapInstace.totalSupply();
    assert.equal(totalSupply.toNumber(), 100000000, 'sets the totalSupply to 1,000,000');
  })
  it('sets the name and symbol upon deployment', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const name = await trixswapInstace.name();
    const symbol = await trixswapInstace.symbol();
    assert.equal(name, "Trixswap", 'sets the name to be set');
    assert.equal(symbol, "TXSW", 'sets the totalSupply to 1,000,000');
  })

  it('Read a balance', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const balance = await trixswapInstace.balanceOf("0x389e027EF510D52628f7B436DdaB3c03F5Fe8C85");
    console.log(balance.toNumber())
    assert.equal(balance.toNumber(), 100000000, 'read the admin balance');
  })

  it('Mint Some new Tokens', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const mintingStatus = await trixswapInstace.mint(1000);
    console.log(mintingStatus)
    // assert.equal(mintingStatus, true, 'should mine some new tokens');
    const balance = await trixswapInstace.balanceOf("0x389e027EF510D52628f7B436DdaB3c03F5Fe8C85");
    console.log(balance.toNumber())
    assert.equal(balance.toNumber(), 100000000 + 1000, 'read the admin balance');
  })

  it('Transfer some tokens', async () => {
    const trixswapInstace = await Trixswap.deployed();
    const mintingStatus = await trixswapInstace.transfer("0xfC269281813299f97b614B6EBC2CCC7b5d0D150C",10000);
    // assert.equal(mintingStatus, true, 'should mine some new tokens');
    const balance = await trixswapInstace.balanceOf("0xfC269281813299f97b614B6EBC2CCC7b5d0D150C");
    console.log(balance.toNumber())
    assert.equal(balance.toNumber(), 10000, 'read the new balance');
  })


})