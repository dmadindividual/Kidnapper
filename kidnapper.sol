// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Kidnapper {
    address public owner;
    address payable public kidnapper = payable(0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2);
    address[] public contributors;
    uint256 public value;
    mapping(address => uint256) public contributefunds;
    mapping(address => bool) public hasSentFunds;
    address public family = 0xdD870fA1b7C4700F2BD7f44238821C26f7392148;
    bool public victimSeen;

    constructor() payable {
        require(kidnapper != msg.sender, "Cannot make calls");
        require(family != msg.sender, "Cannot make calls");
        owner = msg.sender;
        value = msg.value;
    }

    modifier OnlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    function sendFunds() public payable {
        require(!hasSentFunds[msg.sender], "Funds already sent");
        value += msg.value;

        require(kidnapper != msg.sender, "Receiver cannot collect funds");
        require(family != msg.sender, "Receiver cannot collect funds");
        require(owner != msg.sender, "Receiver cannot collect funds");

        contributefunds[msg.sender] += msg.value;
        contributors.push(msg.sender);
        hasSentFunds[msg.sender] = true;
    }

    function balances() public view returns (uint256) {
        return address(this).balance;
    }

    modifier VictimAlert() {
        require(!victimSeen, "We haven't seen the person");
        require(msg.sender == family, "Only family");
        _;
    }

    function notified() public VictimAlert {
        victimSeen = true;
    }

    function payKidnapper() public OnlyOwner {
        require(victimSeen, "Victim hasn't been seen yet");
        require(address(this).balance > 0, "No funds available for payment");

        // Send the entire contract balance to the kidnapper
        kidnapper.transfer(address(this).balance);
    }


  

  
}
