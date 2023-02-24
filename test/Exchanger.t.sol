// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {ERC20} from "openzeppelin/contracts/token/ERC20/ERC20.sol";
import {Ownable} from "openzeppelin/contracts/access/Ownable.sol";
import {Exchanger} from "../src/Exchanger.sol";
import {Issueable} from "../src/IssueableInterface.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";
import {console} from 'forge-std/console.sol';
import {SafeERC20} from 'openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol';

contract ExcangerTest is Test {
  using SafeERC20 for ERC20;
  Exchanger exchanger;
  // ETH USDT https://etherscan.io/address/0xdAC17F958D2ee523a2206206994597C13D831ec7
  ERC20 constant USDT = ERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

  address user1 = 0xCbA38020cd7B6F51Df6AFaf507685aDd148F6ab6;
  address user2 = 0xEEA81C4416d71CeF071224611359F6F99A4c4294;

  function setUp() public {
    vm.createSelectFork("https://eth-mainnet.g.alchemy.com/v2/UXIG2RYPxgZsN8aaQ9oIWYOCsLVUSvSK");

    vm.label(user1, "User 1");
    vm.label(user2, "User 2");
    vm.label(address(USDT), "USDT");


    vm.deal(user1, 100 ether);
    vm.deal(user2, 100 ether);

    exchanger = new Exchanger();
  }

  function testStartExhange() external {
    uint256 EXCHANGE_AMOUNT = 100_000_000;
    uint256 prevBal = USDT.balanceOf(user1);
    vm.startPrank(user1);
    USDT.safeApprove(address(exchanger), EXCHANGE_AMOUNT);

    prevBal = USDT.balanceOf(user1);
    console.log(prevBal);
    exchanger.createExchange(user2, EXCHANGE_AMOUNT, 60, keccak256("kediler"));
    // TODO check ExchangeInitiated(id: 0, from: User 1: [0xF977814e90dA44bFA03b6295A0616a897441aceC], to: User 2: [0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503])
    vm.changePrank(user2);
    // TODO check wrong key
    exchanger.redeem(0, bytes("kediler"));
    // TODO check balances
    // TODO fail second redeem
    // TODO cancel fails now and after expire
  }

  // TODO check cancel
}
