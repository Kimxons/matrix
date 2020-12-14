// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

contract Registrations {
    mapping(address => bool) registered;
    address public owner;
    constructor() public {
        owner = msg.sender;
    }
    function isRegistered(address user) public view returns (bool) {
        return registered[user];

    }
    modifier onlyOwner() {
        require(msg.sender == owner, "Access denied");
        _;

    }
    function register(address user) public {
        registered[user] = true;
    }

}
