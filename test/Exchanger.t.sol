// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {IERC20} from "openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Exchanger} from "../src/Exchanger.sol";
import {stdStorage, StdStorage, Test} from "forge-std/Test.sol";

contract ExcangerTest is Test {
    Exchanger exchanger;
    IERC20 constant USDT = IERC20(0x4Fabb145d64652a948d72533023f6E7A623C7C53);

    address user1 = 0xF977814e90dA44bFA03b6295A0616a897441aceC;
    address user2 = 0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503;

    function setUp() public {
        uint256 ethFork = vm.createFork("https://eth.llamarpc.com");
        vm.selectFork(ethFork);
        exchanger = new Exchanger();

        vm.label(user1, "User 1");
        vm.label(user2, "User 2");

        vm.prank(user1);
        USDT.approve(address(exchanger), 1e18);
    }

    function testStartExhange() external {
        vm.prank(user1);
        exchanger.createExchange(user2, 1e18, 60, keccak256("kediler"));
        // TODO check ExchangeInitiated(id: 0, from: User 1: [0xF977814e90dA44bFA03b6295A0616a897441aceC], to: User 2: [0x47ac0Fb4F2D84898e4D9E7b4DaB3C24507a6D503])
        vm.prank(user2);
        // TODO check wrong key
        exchanger.redeem(0, bytes("kediler"));
        // TODO check balances
        // TODO fail second redeem
        // TODO cancel fails now and after expire
    }

    // TODO check cancel
}
