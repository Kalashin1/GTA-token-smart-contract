// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
pragma experimental ABIEncoderV2;

contract TrixswapStakable {

  uint256 rewardsPerHour = 1000;


  constructor() public {
  }

  // represents a stake
  // every stake has a user, amount and timestamp when it was made
  struct Stake {
    address user;
    uint256 amount;
    uint256 since;
    uint256 claimable;
  }

  struct StakingSummary{
    uint256 total_amount;
    Stake[] stakes;
  }

  // staker with active stakes
  struct Stakeholder {
    address user;
    Stake[] user_stakes;
  }

  /// location of stakes in the contract
  /// stakes for a particular address is stored at an index mapped to the address in the
  /// stakes mapping
  Stakeholder[] internal stakeholders;

  /// maps an address to an integer that represents thier index
  /// in the stakes array
  mapping(address => uint256) internal stakes;

  /// @notice Stake Fired anytime there is a stake
  /// @dev Explain to a developer any extra details
  /// @param user the user that just staked
  /// @param amount the tokens the user staked
  event Staked(
    address indexed user,
    uint256 indexed amount,
    uint256 index,
    uint256 indexed timestamp
  );

  function _addStakeHolder(address user) internal returns(uint256) {
    uint256 index = stakeholders.length - 1;
    stakeholders[index].user = user;
    stakes[user] = index;
    return index;
  }

  function _stake(uint256 amount) internal  {
    require(amount > 0, "cannot stake nothing");

    uint256 stakingIndex = stakes[msg.sender];
    uint256 timestamp = block.timestamp;

    if(stakingIndex == 0){
      stakingIndex = _addStakeHolder(msg.sender);
    }

    stakeholders[stakingIndex].user_stakes.push(Stake(msg.sender, amount, timestamp, 0));
    emit Staked(msg.sender, amount, stakingIndex, timestamp);
  }

  function calculateStakeReward(Stake memory stake) internal view returns(uint256){
    return (((block.timestamp - stake.since)/ 1 hours) * stake.amount) / rewardsPerHour;
  }

  function hasStake(address staker) public view returns(StakingSummary memory){
    uint256 totalStakedAmount;
    StakingSummary memory summary = StakingSummary(0, stakeholders[stakes[staker]].user_stakes);
    
    for(uint256 s = 0; s < summary.stakes.length; s++){
      uint256 availableReward = calculateStakeReward(summary.stakes[s]);
      summary.stakes[s].claimable = availableReward;
      totalStakedAmount = totalStakedAmount + summary.stakes[s].amount;
    }
    summary.total_amount = totalStakedAmount;
    return summary;
  }

  function _withdrawStake(uint256 amount, uint256 index) internal returns(uint256){
    // Grab user_index which is the index to use to grab the Stake[]
    uint256 user_index = stakes[msg.sender];
    Stake memory current_stake = stakeholders[user_index].user_stakes[index];
    require(current_stake.amount >= amount, "Staking: Cannot withdraw more than you have staked");

    // Calculate available Reward first before we start modifying data
    uint256 reward = calculateStakeReward(current_stake);
    // Remove by subtracting the money unstaked 
    current_stake.amount = current_stake.amount - amount;
    // If stake is empty, 0, then remove it from the array of stakes
    if(current_stake.amount == 0){
        delete stakeholders[user_index].user_stakes[index];
    }else {
        // If not empty then replace the value of it
        stakeholders[user_index].user_stakes[index].amount = current_stake.amount;
        // Reset timer of stake
        stakeholders[user_index].user_stakes[index].since = block.timestamp;    
    }

    return amount+reward;
  }
}
