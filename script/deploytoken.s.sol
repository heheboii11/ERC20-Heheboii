//SPDX-License-Identifier:MIT

pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {heheboii} from "../src/ourToken.sol";

contract deploytoken is Script {
    heheboii token;

    function run() external returns (heheboii) {
        vm.startBroadcast();
        token = new heheboii(1000 ether);
        vm.stopBroadcast();
        return token;
    }
}
