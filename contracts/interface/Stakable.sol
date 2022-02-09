// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract TrixswapStakable {

  uint256 rewardsPerHour = 1000;

  constructor () public {
    
  }

  struct Stake {
    address owner;
    uint256 amount;
    uint256 stakeDate;
  }

  struct StakeHolder {
    Stake[] stakes;
    uint256 totalAmountStaked;
  }

  mapping (address => StakeHolder) stakeHolders;

  function _stake(uint256 amount) internal returns (bool) {
    
    require(amount > 0, "cannot stake an empty staking");
    bool hasStaked = _hasStaked(msg.sender);

    if(hasStaked){
      Stake memory newStake = Stake(msg.sender, amount, block.timestamp);
      stakeHolders[msg.sender].stakes.push(newStake);
      stakeHolders[msg.sender].totalAmountStaked += amount;
      emit Staked(msg.sender, amount, now);
      return true;
    } else {
      Stake memory newStake = Stake(msg.sender, amount, block.timestamp);
      stakeHolders[msg.sender].stakes.push(newStake);
      stakeHolders[msg.sender].totalAmountStaked = amount;
      emit Staked(msg.sender, amount, now);
      return true;
    }
  }

  function _hasStaked(address staker) internal returns (bool) {
    StakeHolder memory currentStakeHolder = stakeHolders[staker];
    if( currentStakeHolder.stakes.length > 0){
      return true;
    } else {
      return false;
    }
  }

  function _unStake(uint256 amount) internal returns(bool) {
    bool hasStaked = _hasStaked(msg.sender);
    require(hasStaked, "You have to stake first before you can unstake");
    stakeHolders[msg.sender].totalAmountStaked -= amount;
    return true;
  }

  event Staked(address indexed staker, uint256 indexed stakedAmount, uint256 indexed stakeDate);
  
}
