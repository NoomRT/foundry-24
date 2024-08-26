// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test} from "forge-std/Test.sol";
import {DeployOurToken} from "../script/DeployOurToken.s.sol";
import {OurToken} from "../src/OurToken.sol";

interface IMintableToken {
    function mint(address, uint256) external;
}

contract OurTokenTest is Test {
    OurToken public ourToken;
    DeployOurToken public deployer;

    address bob = makeAddr("bob");
    address alice = makeAddr("alice");

    uint256 public constant STARTING_BALANCE = 100 ether;

    function setUp() public {
        deployer = new DeployOurToken();
        ourToken = deployer.run();

        vm.prank(msg.sender);
        ourToken.transfer(bob, STARTING_BALANCE);
    }

    // Asking Gemini to do additional tests covering allowances, transfers (including edge cases), and other important functionalities

    // Test initial supply
    function testInitialSupply() public {
        assertEq(ourToken.totalSupply(), deployer.INITIAL_SUPPLY());
    }

    // Test users can't mint (already covered)

    // Test Bob's balance
    function testBobBalance() public {
        assertEq(STARTING_BALANCE, ourToken.balanceOf(bob));
    }

    // Allowances tests

    function testZeroAllowance() public {
        vm.prank(bob);
        vm.expectRevert(); // "ERC20: insufficient allowance"
        ourToken.transferFrom(bob, alice, 1 ether);
    }

    function testInsufficientAllowance() public {
        uint256 allowance = 1 ether;
        vm.prank(bob);
        ourToken.approve(alice, allowance);

        vm.prank(alice);
        vm.expectRevert(); // "ERC20: transfer amount exceeds allowance"
        ourToken.transferFrom(bob, alice, allowance + 1 ether);
    }

    function testAllowanceReset() public {
        uint256 allowance = 1 ether;
        vm.prank(bob);
        ourToken.approve(alice, allowance);

        uint256 transferAmount = 500;
        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount);

        // Approve Alice with a new allowance
        vm.prank(bob);
        ourToken.approve(alice, 1000);

        vm.prank(alice);
        ourToken.transferFrom(bob, alice, transferAmount); // Should succeed using the new allowance
    }

    // Transfer tests

    function testTransferOwnership() public {
        uint256 transferAmount = 25 ether;
        vm.prank(bob);
        ourToken.transfer(alice, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE - transferAmount);
        assertEq(ourToken.balanceOf(alice), transferAmount);
    }

    function testTransferZeroAmount() public {
        vm.prank(bob);
        ourToken.transfer(alice, 0);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
        assertEq(ourToken.balanceOf(alice), 0);
    }

    function testTransferToSelf() public {
        uint256 transferAmount = 25 ether;
        vm.prank(bob);
        ourToken.transfer(bob, transferAmount);

        assertEq(ourToken.balanceOf(bob), STARTING_BALANCE);
    }

    function testTransferOverflow() public {
        vm.expectRevert(); // "ERC20: transfer amount exceeds balance"
        vm.prank(bob);
        ourToken.transfer(alice, STARTING_BALANCE + 1 ether);
    }

    function testUsersCantMintToken() public {
        vm.expectRevert();
        IMintableToken(address(ourToken)).mint(address(this), 1);
    }

    // Additional tests you might consider

    //   function testBurnFunctionality(bool shouldRevert) public {
    //     if (shouldRevert) {
    //       vm.expectRevert();
    //     }

    //     // Implement logic to attempt burning tokens (if your token supports burning)
    //   }

    //   function testMintingFunctionality(bool shouldRevert) public {
    //     if (shouldRevert) {
    //       vm.expectRevert();
    //     }

    //     // Implement logic to attempt minting tokens (if your contract allows minting)
    //   }
}
