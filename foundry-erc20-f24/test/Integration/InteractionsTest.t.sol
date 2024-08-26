// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "forge-std/Test.sol";
import {OurTokenInteractions} from "../../script/Interactions.s.sol";
import {DeployOurToken} from "../../script/DeployOurToken.s.sol";
import {OurToken} from "../../src/OurToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


interface IBurnToken {
    function burn(address, uint256) external;
}

interface IMintMoreToken {
    function mint(address, uint256) external;
}

contract InterationsTest is Test {
    OurToken public ourToken;
    DeployOurToken deployer;

    address alice = makeAddr("alice");
    address bob = makeAddr("bob");

    uint256 private constant STARTING_BALANCE = 100 ether;
    
    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    function testTransferFromAllowances() public {
        uint256 AMOUNT = 50 ether;

        vm.prank(bob);
        ourToken.approve(alice, AMOUNT);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, AMOUNT);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - AMOUNT);
        assertEq(ourToken.balanceOf(alice), AMOUNT);
    }

    function testOwnerMintMoreToken() public {
        uint256 mintMoreAmount = 100 ether;
        vm.prank(msg.sender);
        IMintMoreToken(address(ourToken)).mint(msg.sender, mintMoreAmount);
        assertEq(ourToken.balanceOf(msg.sender), (ourToken.balanceOf(msg.sender) + mintMoreAmount) - STARTING_BALANCE);
    }

    function testOwnerBurnToken() public {
        uint256 burnAmount = 100 ether;
        vm.prank(msg.sender);
        IBurnToken(address(ourToken)).burn(msg.sender, burnAmount);
        assertEq(ourToken.balanceOf(msg.sender),  (ourToken.balanceOf(msg.sender) + burnAmount) - STARTING_BALANCE);
    }
}