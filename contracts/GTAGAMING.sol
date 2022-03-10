// SPDX-License-Identifier: MIT
pragma solidity > 0.8.0;
// pragma experimental ABIEncoderV2;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GTAGAMING is ERC20 {

  uint256 private constant _DECIMALS = 18;

  uint256 private leastStakePeriod = 3 days;

  uint256 private TOTAL_SUPPLY = 600000000 * (10**_DECIMALS);

  uint256 private _CIRCULATING_SUPPLY = TOTAL_SUPPLY / 4;

  uint256 private _REWARD_SUPPLY = TOTAL_SUPPLY / 3;
  
  uint256 private ContractReward = 13 * (10**(_DECIMALS - 2));

  constructor() ERC20("grandtheftgaming", "GTA") {
    _mint(msg.sender, TOTAL_SUPPLY);
  }

  function _address() public view returns (address) {
    return payable(address(this));
  }


  function _circulatingSupply() public view returns (uint256) {
    return _CIRCULATING_SUPPLY;
  }

  function _rewardSupply() public view returns (uint256) {
    return _REWARD_SUPPLY;
  }

  function receive() external payable {
    emit Transfer(msg.sender, address(this), msg.value);  
  }

  function getBalance() public view returns (uint256) {
    return address(this).balance;
  }

  // represents a stake
  struct Stake {
    uint256 amount;
    uint256 time;
  }

  function _isPastMinimumStakePeriod(address owner) private view returns (bool) {
    require(_userHasStaked(owner));
    Stake storage userStake = CurrentStakes[owner];
    if(block.timestamp > userStake.time + leastStakePeriod) return true;
    return false;
  }

  function _calculateReward(address owner) private view returns (uint256) {
    require(_userHasStaked(owner));
    Stake storage userStake = CurrentStakes[owner];
    uint256 stakedAmount = userStake.amount;
    uint256 stakedTime = (block.timestamp * 365 days)/ 6 seconds; // TODO change 100 days to userStake.time * block.timestamp
    uint256 _reward = (stakedAmount/ContractReward) * stakedTime;
    return _reward; 
  }

  mapping(address => bool) StakedUsers;

  mapping(address => Stake) CurrentStakes;
  
  // emitted when ever a user stakes into the smart contract
  event Staked (address indexed owner, uint256 indexed amount, uint256 indexed time);
  
  // emitted when ever a user stakes into the smart contract
  event Unstaked (address indexed owner, uint256 indexed amount, uint256 indexed time);

  function _stake(address owner, uint256 amount) private returns (bool) {
    bool hasUserStaked = _userHasStaked(owner);
    if(hasUserStaked) {
      Stake storage userStake = CurrentStakes[owner];
      userStake.amount += amount;
    } else {
      CurrentStakes[owner] = Stake(amount, block.timestamp);
      emit Staked(owner, amount, block.timestamp);
      StakedUsers[owner] = true;
    }
    return true;
  }

  function _userHasStaked(address user) view private returns (bool) {
    if (StakedUsers[user]) return true;
    return false;
  }

  function _getTotalStakedAmout(address owner) view public returns (uint256) {
    require(_userHasStaked(owner),"You must stake your tokens first. To view your stakeBalance");
    Stake storage userStake = CurrentStakes[owner];
    return userStake.amount;
  }

  function _getInitialStakeDate(address owner) view public returns (uint256) {
    require(_userHasStaked(owner), "You must stake your tokens first. To view your stakeBalance");
    Stake storage userStake = CurrentStakes[owner];
    return userStake.time;
  }

  function _unstake(address user, uint256 amount) private returns (bool) {
    require(_userHasStaked(user));
    require(_isPastMinimumStakePeriod(user), "Not past the minimum stake period");
    Stake storage userStake = CurrentStakes[user];
    require(userStake.amount > amount);
    userStake.amount -= amount;
    return true;
  }


  function stake(address owner, uint256 amount) public returns (bool) {
    bool res = _stake(owner, amount);
    if (res) {
      _burn(owner, amount);
      emit Staked(owner, amount, block.timestamp);
      return true;
    } else { 
      return false;
    }
  }

  function unstake(address owner, uint256 amount) public returns (bool) {
    bool res = _unstake(owner, amount);
    if(res){
      _mint(owner, amount);
      emit Unstaked(owner, amount, block.timestamp);
      return true;
    } else {
      return false;
    }
  }

  function showReward(address owner) public view returns (uint256){
    uint256 _Reward = _calculateReward(owner);
    return _Reward;
  }
}  