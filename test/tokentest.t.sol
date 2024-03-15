//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;
import {Test} from "forge-std/Test.sol";
//import {Console} from "forge-std/Script.sol";
import "forge-std/console.sol";
import {heheboii} from "../src/ourToken.sol";
import {deploytoken} from "../script/deploytoken.s.sol";

contract Ourtokentest is Test {
    deploytoken deploy;
    heheboii public ourtoken;
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    uint256 Startingbalance = 100 ether;

    function setUp() public {
        deploy = new deploytoken();
        ourtoken = deploy.run();
        vm.prank(msg.sender);
        ourtoken.transfer(bob, Startingbalance);
    }

    function testbobbalance() public {
        uint256 balanceOfBob = ourtoken.balanceOf(bob);
        console.log(balanceOfBob);
        assertEq(balanceOfBob, Startingbalance);
    }

    function testallowance() public {
        uint256 approvaltoken = 1000;
        uint256 transferamount = 50;
        vm.prank(bob);
        ourtoken.approve(alice, approvaltoken);

        vm.prank(alice);
        ourtoken.transferFrom(bob, alice, transferamount);

        assertEq(ourtoken.balanceOf(alice), transferamount);
        assertEq(ourtoken.balanceOf(bob), Startingbalance - transferamount);
    }

    function testTransfer() public {
        uint256 transferAmount = 25 ether;

        // Test successful transfer from deployer to bob
        vm.prank(msg.sender);
        ourtoken.transfer(bob, transferAmount);

        uint256 bobBalance = ourtoken.balanceOf(bob);
        console.log(bobBalance);
        assertEq(bobBalance, Startingbalance + transferAmount);

        uint256 deployerBalance = ourtoken.balanceOf(msg.sender);
        console.log(deployerBalance);
        assertEq(
            deployerBalance,
            1000 ether - (Startingbalance + transferAmount)
        );

        // Test insufficient balance scenario
        vm.prank(msg.sender);
        vm.expectRevert();
        ourtoken.transfer(bob, 1000 ether + 1 ether); // Revert expected
    }
}
