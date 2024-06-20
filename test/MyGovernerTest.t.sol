// SPDX-License-Identifier: MIT

pragma solidity 0.8.22;

import {Test, console} from "forge-std/Test.sol";
import {Box} from "../src/Box.sol";
import {GovToken} from "../src/GovToken.sol";
import {TimeLock} from "../src/TimeLock.sol";
import {MyGovernor} from "../src/MyGovernor.sol";

contract MyGovernorTest is Test {
    Box box;
    MyGovernor governor;
    GovToken token;
    TimeLock timelock;

    address[] proposers;
    address[] executers;

    uint256[] values;
    bytes[] calldatas;
    address[] targets;

    uint256 public constant INITIAL_SUPPLY = 100 ether;

    uint256 public constant MIN_DELAY = 3600;

    uint256 public constant VOTING_DELAY = 1;

    uint256 public constant VOTING_PERIOD = 50400;

    address public USER = makeAddr("user");

    function setUp() public {
        token = new GovToken();
        token.mint(USER, INITIAL_SUPPLY);
        vm.startPrank(USER);
        token.delegate(USER);
        timelock = new TimeLock(MIN_DELAY, proposers, executers);
        governor = new MyGovernor(token, timelock);

        bytes32 proposerRole = timelock.PROPOSER_ROLE();
        bytes32 executorRole = timelock.EXECUTOR_ROLE();
        bytes32 adminRole = timelock.TIMELOCK_ADMIN_ROLE();

        timelock.grantRole(proposerRole, address(governor));
        timelock.grantRole(executorRole, address(0));
        timelock.revokeRole(adminRole, USER);
        vm.stopPrank();
        box = new Box();
        box.transferOwnership(address(timelock));
    }

    function testCantUpdateBoxWithoutGovernance() public {
        vm.expectRevert();
        box.store(1);
    }

    function testGovernanceUpdatesBox() public {
        uint256 valueToStore = 777;
        string memory description = "Store 777 in Box";
        bytes memory encodedFunctionCall = abi.encodeWithSignature("store(uint256)", valueToStore);
        calldatas.push(encodedFunctionCall);
        values.push(0);
        targets.push(address(box));

        // propose to DAO
        uint256 proposalId = governor.propose(targets, values, calldatas, description);

        // view the state of the proposal
        console.log("Proposal State", uint256(governor.state(proposalId)));

        vm.warp(block.timestamp + VOTING_DELAY + 1);
        vm.roll(block.number + VOTING_DELAY + 1);
        console.log("Proposal State", uint256(governor.state(proposalId)));

        // vote
        // against:0 for:1 abstain:2
        uint8 voteWay = 1;
        string memory reason = "I like it";
        vm.prank(USER);
        governor.castVoteWithReason(proposalId, voteWay, reason);

        vm.warp(block.timestamp + VOTING_PERIOD + 1);
        vm.roll(block.number + VOTING_PERIOD + 1);

        // queue
        bytes32 descriptionHash = keccak256(abi.encodePacked(description));
        governor.queue(targets, values, calldatas, descriptionHash);

        vm.warp(block.timestamp + MIN_DELAY + 1);
        vm.roll(block.number + MIN_DELAY + 1);

        // execute
        governor.execute(targets, values, calldatas, descriptionHash);

        assert(box.getNumber() == valueToStore);
        console.log("Box Value: ", box.getNumber());
    }
}
