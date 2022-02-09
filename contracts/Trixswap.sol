// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;
// pragma experimental ABIEncoderV2;

import "./interface/IERC20.sol";
import "./lib/SafeMath.sol";
import "./interface/Stakable.sol";

contract Trixswap is ITrixswapERC20, TrixswapStakable {
  // state variable
  uint256 public totalSupply;
  // type modifier name
  address public owner = msg.sender;

  mapping(address => uint256) balances;
  mapping(address => mapping(address => uint256)) allowed;

  constructor(uint256 _totalSupply) public {
      totalSupply = _totalSupply;
      balances[msg.sender] += totalSupply;
  }

  function name() external pure returns (string memory) {
      return "Trixswap";
  }

  function symbol() external pure returns (string memory) {
      return "TXSW";
  }

  function decimals() external pure returns (uint256) {
      return 18;
  }

  function balanceOf(address tokenOwner) external view returns (uint256) {
      return balances[tokenOwner];
  }

  function transfer(address to, uint256 tokens) external returns (bool) {
      require(balances[msg.sender] > tokens);
      require(tokens > 0);
      balances[to] += tokens;
      balances[msg.sender] -= tokens;
      emit Transfer(msg.sender, to, tokens);
      return true;
  }

  function transferFrom(
      address from,
      address to,
      uint256 tokens
  ) external returns (bool) {
      require(balances[from] >= tokens);
      require(tokens > 0);
      balances[from] -= tokens;
      balances[to] += tokens;
      return true;
  }

  function approve(address spender, uint256 tokens) external returns (bool) {
      allowed[msg.sender][spender] = tokens;
      emit Approval(msg.sender, spender, tokens);
      return true;
  }

  function allowance(address tokenOwner, address spender)
      public
      view
      returns (uint256 remaining)
  {
      return allowed[tokenOwner][spender];
  }

  function _mint(uint256 tokens) internal returns (bool success) {
      balances[msg.sender] += tokens;
      totalSupply += tokens;
      emit Minting(msg.sender, tokens);
      return true;
  }

	function mint(uint256 tokens) external returns (bool){
		require(msg.sender == owner, "Only admins can call this function");
		return _mint(tokens);
	}

  function _burn(address account, uint256 amount) internal {
      require(
          account != address(0),
          "DevToken: cannot burn from zero address"
      );
      require(
          balances[account] >= amount,
          "DevToken: Cannot burn more than the account owns"
      );

      // Remove the amount from the account balance
      balances[account] -= amount;
      // Decrease totalSupply
      totalSupply -= amount;
      // Emit event, use zero address as reciever
      emit Transfer(account, address(0), amount);
  }

  function burn(address account, uint256 amount)
      public
      returns (bool)
  {
    require(msg.sender == owner, "you don't have access to call that");
      _burn(account, amount);
      return true;
  }

  function stake(uint256 amount) public returns(bool){
    require(amount < balances[msg.sender]);
    bool stakingStatus = _stake(amount);
    if(stakingStatus){
    _burn(msg.sender, amount);
    return stakingStatus;
    } else {
			return false;
    }
  }

  function hasStaked(address staker) public returns(bool) {
    return _hasStaked(staker);
  }

  function unstake(uint256 amount) public returns(bool) {
		bool unstakeStatus = _unStake(amount);
		if(unstakeStatus){
			_mint(amount);
			return unstakeStatus;
		}
  }

  
  event Approval(
      address indexed tokenOwner,
      address indexed spender,
      address indexed tokens
  );
  event Transfer(
      address indexed from,
      address indexed to,
      address indexed tokens
  );
}
