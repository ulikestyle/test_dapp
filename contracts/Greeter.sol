//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract Greeter {
    string greeting;
    string counter;

    constructor(string memory _greeting) {
        console.log("Deploying a Greeter with greeting:", _greeting);
        greeting = _greeting;
        counter = "test";
    }

    function greet() public view returns (string memory) {
        return greeting;
    }

    function count() public view returns (string memory) {
        return counter;
    }

    function setGreeting(string memory _greeting) public {
        console.log("Changing greeting from '%s' to '%s'", greeting, _greeting);
        greeting = _greeting;
    }

    function setCounter(string memory _counter) public {
        console.log("Changing counter from '%s' to '%s'", counter, _counter);
        counter = _counter;
    }
}
