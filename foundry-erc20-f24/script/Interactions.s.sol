// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script, console} from "forge-std/Script.sol";
import {OurToken} from "../src/OurToken.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract OurTokenInteractions is Script {
    function ourTokenInteractions(address mostRecentlyDeployed) public {
        vm.startBroadcast();
        OurToken(payable(mostRecentlyDeployed));
        vm.stopBroadcast();
        console.log("Owner mint token!");
    }

    function run() external {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("OurToken", block.chainid);
        ourTokenInteractions(mostRecentlyDeployed);
    }
}