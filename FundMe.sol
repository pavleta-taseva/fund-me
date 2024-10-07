// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { PriceConverter } from "./PriceConverter.sol";
//Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

contract FundMe {
    using PriceConverter for uint256;
    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    function fund() public payable {
        // Allow users to send money
        // Have minimum $ send, use Oracle to get the real price of the ETH in USD
        // 1. How do we send ETH to this contract?
        // What is a revert? It undoes any actions that have been done, and send the remaining gas back
        require ( msg.value.getConvertionRate() >= 1e18, "Not enough ETH provided"); // 1e18 = 10^18 (1 * 10 ** 18) = 1 ETH 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // Amount funded by this address in USD
    }

    function withdraw(uint256 amount) public {
    }
}