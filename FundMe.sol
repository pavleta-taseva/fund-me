// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import { PriceConverter } from "./PriceConverter.sol";
//Get funds from users
// Withdraw funds
// Set a minimum funding value in USD

contract FundMe {
    using PriceConverter for uint256;
    uint256 public constant MINIMUM_USD = 5e18;

    address[] public funders;
    address public immutable i_owner;
    mapping(address funder => uint256 amountFunded) public addressToAmountFunded;

    constructor() {
        i_owner = msg.sender;
    }

    function fund() public payable {
        // Allow users to send money
        // Have minimum $ send, use Oracle to get the real price of the ETH in USD
        // 1. How do we send ETH to this contract?
        // What is a revert? It undoes any actions that have been done, and send the remaining gas back
        require ( msg.value.getConvertionRate() >= MINIMUM_USD, "Not enough ETH provided"); // 1e18 = 10^18 (1 * 10 ** 18) = 1 ETH 
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value; // Amount funded by this address in USD
    }

    function withdraw() public onlyOwner {
        // for loop (starting index, edning index, step amount)
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex]; 
            addressToAmountFunded[funder] = 0;
        }
        //reset array of funders
        funders = new address[](0);
        //withdraw funds - transfer, send, call
        //payable(msg.sender) = payable address

        //transfer - reverts automatically if the transfer fails
        // payable(msg.sender).transfer(address(this).balance);

        // send - only reverts if we fail and have the require statement
        // bool sendSuccess = payable(msg.sender).send(address(this).balance);
        // require(sendSuccess, "SEND FAILED");

        //call
        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "CALL FAILED");
    }

    // modifier acts like middleware in JS
    modifier onlyOwner () {
        require(msg.sender == i_owner, "Must be owner!");
        _;
    }
}