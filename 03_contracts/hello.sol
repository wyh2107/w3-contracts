// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Admin {

    mapping(address => uint256) public balances;

    address owner;

    uint public count;

    constructor() {
        owner = msg.sender;
    }

    function addCount() public {
        count += 1;
    }




}