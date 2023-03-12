// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import {IERC20} from "openzeppelin/contracts/token/ERC20/IERC20.sol";
import {Exchanger} from "../src/Exchanger.sol";

contract ExchangerScript is Script {
    function setUp() public {}

    function run() public {
        vm.broadcast();
        new Exchanger(IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7));
    }
}
