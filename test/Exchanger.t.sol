// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";
import {Exchanger} from "../src/Exchanger.sol";
import {Issueable} from "../src/IssueableInterface.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from 'forge-std/console.sol';

contract ExcangerTest is Test {
  Exchanger exchanger;
  // ETH USDT https://etherscan.io/address/0xdAC17F958D2ee523a2206206994597C13D831ec7
  ERC20 constant USDT = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

  address user1 = 0x65A0947BA5175359Bb457D3b34491eDf4cBF7997;
  address user2 = 0xe9172Daf64b05B26eb18f07aC8d6D723aCB48f99;

  function setUp() public {
    vm.createSelectFork("https://rpc.payload.de");
    exchanger = new Exchanger();

    vm.label(user1, "User 1");
    vm.label(user2, "User 2");


    vm.deal(user1, 100 ether);
    vm.deal(user2, 100 ether);

    // vm.prank(user1);
    // USDT.transfer(user2, 100);

    // vm.prank(user1);
    // console.log(USDT.allowance(address(exchanger), user1));
    // USDT.increaseAllowance(0xdAC17F958D2ee523a2206206994597C13D831ec7, 2 * 1e6);
    // USDT.approve(address(exchanger), 5 * 1e6);
  }

  function testApprove() external {
    console.log(USDT.allowance(user2, user1));
    console.log(USDT.allowance(user1, user2));
    console.log("APPROVE PLACE");
    vm.prank(user1);
    USDT.approve(user2, 5 * 1e6);
    console.log(USDT.allowance(user2, user1));
    console.log(USDT.allowance(user1, user2));
  }

  // function testStartExhange() external {
  //   address usdcOwner = Ownable(address(USDT)).owner();
  //   vm.deal(usdcOwner, 100 ether);
  //   uint256 prevBal = USDT.balanceOf(usdcOwner);
  //   vm.prank(usdcOwner);
  //   Issueable(address(USDT)).issue(100 * 1e6);
  //   console.log("ISSUED:");
  //   console.log(USDT.balanceOf(usdcOwner) - prevBal);

  //   prevBal = USDT.balanceOf(usdcOwner);
  //   vm.prank(usdcOwner);
  //   USDT.transfer(user1, 500);
  //   console.log("AFTER TRANSFER OF:");
  //   console.log(USDT.balanceOf(usdcOwner) - prevBal);
  //   // vm.prank(user1);
  //   // exchanger.createExchange(user2, 1e6, 60, keccak256("kediler"));
  //   // TODO check ExchangeInitiated(id: 0, from: User 1: [0xF977814e90dA44bFA03b6295A0616a897441aceC], to: User 2: [0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503])
  //   // vm.prank(user2);
  //   // TODO check wrong key
  //   // exchanger.redeem(0, bytes("kediler"));
  //   // TODO check balances
  //   // TODO fail second redeem
  //   // TODO cancel fails now and after expire
  // }

  // TODO check cancel
}
