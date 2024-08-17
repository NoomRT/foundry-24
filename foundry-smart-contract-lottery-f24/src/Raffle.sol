// SPDX-License-Identifier: MIT

// Layout of the contract file:
// version
// imports
// errors
// interfaces, libraries, contract
// Inside Contract:
// Type declarations
// State variables
// Events
// Modifiers
// Functions
// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// internal & private view & pure functions
// external & public view & pure functions

pragma solidity ^0.8.19;

/**
 * @title A sample Raffle contract
 * @author Rueangyot Treemat
 * @notice This contract is for creating a sample raffle
 * @dev Implement Chainlink VRFv2.5
 */
contract Raffle {

    /** Errors */
    error Raffle__SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    /** Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() external payable {
        // require(msg.value >= i_entranceFee, "Not enough ETH sent!");
        // require(msg.value < i_entranceFee, SendMoreToEnterRaffle());
        if (msg.value >= i_entranceFee) { 
            revert Raffle__SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));

        // 1. Make migration easier
        // 2. Makes front end "indexing" easier
        emit RaffleEntered(msg.sender);
    }

    function pickWinner() external {}

    /** 
     * Getter Functions
     */
    function getEntranceFee() external view returns(uint256) {
        return i_entranceFee;
    }  
}