// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {IERC20} from "openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Exchanger {
  event ExchangeInitiated(uint256 id, address from, address to);

  struct Exchange {
    address sender;
    address beneficiar;
    uint256 createdAt;
    uint256 duration; // sec
    uint256 sum;
    bytes32 hash;
    bool finished;
  }

  IERC20 constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);

  Exchange[] public exchanges;

  function createExchange(
    address beneficiar,
    uint256 amount,
    uint256 duration,
    bytes32 hash
  ) external {
    Exchange memory exchange = Exchange(
      msg.sender,
      beneficiar,
      block.timestamp,
      duration,
      amount,
      hash,
      false
    );
    exchanges.push(exchange);
    USDT.transferFrom(msg.sender, address(this), amount);
    emit ExchangeInitiated(exchanges.length - 1, msg.sender, beneficiar);
  }

  function redeem(uint256 id, bytes memory key) external {
    // TODO reentry check
    Exchange storage exchange = exchanges[id];
    require(exchange.finished == false, "Already finished");
    exchange.finished = true;
    require(exchange.hash == keccak256(key), "Bad key");
    require(
      exchange.createdAt + exchange.duration >= block.timestamp,
      "Expired"
    );

    USDT.transfer(exchange.beneficiar, exchange.sum);
  }

  function cancel(uint256 id) external {
    // TODO also can cancel if receiver
    Exchange storage exchange = exchanges[id];
    require(
      exchange.createdAt + exchange.duration < block.timestamp,
      "Not expired"
    );
    require(exchange.finished == false, "Redeemed");
    USDT.transfer(exchange.beneficiar, exchange.sum);
  }
}
