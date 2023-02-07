// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract Counter {
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

  IERC20 constant USDT = IERC20(0x000000000000000000000);

  Exchange[] public exchanges;

  function createExchange(
    address _beneficiar,
    uint256 amount,
    uint256 _duration,
    bytes32 _hash
  ) external {
    Exchange memory _exchange = new Exchange(
      msg.sender,
      _beneficiar,
      block.timestamp,
      _duration,
      amount,
      _hash,
      false
    );
    exchanges.push(_exchange);
    USDT.transferFrom(msg.sender, address(this), amount);
    emit ExchangeInitiated(exchanges.length - 1, msg.sender, _beneficiar);
  }

  function redeem(uint256 id, bytes32 key) external { // TODO reentry check
    Exchange storage exchange = exchanges[id];
    require(exchange.finished == false, 'Already finished');
    exchange.finished = true;
    require(exchange.hash == keccak256(key), 'Bad key');
    require(exchange.createdAt + exchange.duration >= block.timestamp, 'Expired');

    USDT.transferFrom(address(this), exchange.beneficiar, exchange.sum);
  }

  function withdraw(uint256 id) external {
    require(exchange.createdAt + exchange.duration < block.timestamp, 'Not expired');
    USDT.transferFrom(address(this), exchange.beneficiar, exchange.sum);
  }
}
