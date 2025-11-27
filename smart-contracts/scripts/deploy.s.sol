// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {Script, console} from "forge-std/Script.sol";
import {DocumentRegistry} from "../src/DocumentRegistry.sol";

contract DeployScript is Script {
    function run() external returns (DocumentRegistry) {
        // Usar la clave privada por defecto de Anvil si no se especifica
        uint256 deployerPrivateKey;
        try vm.envUint("PRIVATE_KEY") returns (uint256 key) {
            deployerPrivateKey = key;
        } catch {
            // Clave privada por defecto de Anvil (primera cuenta)
            deployerPrivateKey = 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80;
        }
        
        vm.startBroadcast(deployerPrivateKey);
        
        DocumentRegistry registry = new DocumentRegistry();
        
        console.log("DocumentRegistry deployed at:", address(registry));
        console.log("Deployer address:", vm.addr(deployerPrivateKey));
        
        vm.stopBroadcast();
        
        return registry;
    }
}

