/**
 *Submitted for verification at Etherscan.io on 2024-09-05
*/

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract TimeLockWallet {
    address public owner;
    address public beneficiary;
    uint256 public unlockTime;
    uint256 public lockperiod;

    event deposited(address indexed sender, uint256 amount);
    event withdrawn(address indexed recipient, uint256 amount);
    
    constructor(address _beneficiary, uint256 _lockperiod) {
        owner = msg.sender;
        beneficiary = _beneficiary;
        lockperiod = _lockperiod;
        unlockTime = block.timestamp + lockperiod;
    }

    receive() external payable {
        emit deposited(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender == beneficiary, "You are not the beneficiary");
        require(block.timestamp >= unlockTime, "You can't make withdrawals before the unlockTime");
        
        uint256 amount = address(this).balance;
        require(amount > 0, "You have not deposited any funds for withdrawals");

        payable(beneficiary).transfer(amount);
        emit withdrawn(beneficiary, amount);
    }

    function updateBeneficiary(address _newBeneficiary) external {
        require(msg.sender == owner, "You are not the owner");
        beneficiary = _newBeneficiary;
    }
}