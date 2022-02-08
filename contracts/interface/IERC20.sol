// SPDX-License-Identifier: MIT
//ERC Token Standard #20 Interface
pragma solidity >=0.4.22 <0.9.0;
 
interface ITrixswapERC20 {
  function totalSupply() external view returns (uint);
  function balanceOf(address tokenOwner) external view returns (uint balance);
  function allowance(address tokenOwner, address spender) external view returns (uint remaining);

  function mint(uint256 token) external returns (bool);

  function transfer(address to, uint tokens) external returns (bool success);
  function approve(address spender, uint tokens) external returns (bool success);
  function transferFrom(address from, address to, uint tokens) external returns (bool success);

  event Transfer(address indexed from, address indexed to, uint tokens);
  event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
  event Minting(address indexed person, uint indexed tokenNum);
}