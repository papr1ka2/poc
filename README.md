# The Fei Rari Hack Explained

## TL;DR
On April 30, 2022, Fuse of Rari Capital, a decentralized lending platform on the Ethereum blockchain, was hacked with a total loss of $80M. Multiple pools were hacked using flash loan to exploit a simple re-entrancy bug in the Compound code they were based on. Currently, 

## Transaction
7 attack transactions drained tokens from various lending pools. Check the [attacker's address](https://etherscan.io/address/0x6162759edad730152f0df8115c698a42e666157f) to view all the attack transactions. The attack is consisted of two contracts ([1](https://etherscan.io/address/0x6162759edad730152f0df8115c698a42e666157f), [2](https://etherscan.io/address/0x6162759edad730152f0df8115c698a42e666157f)). In this post, we will discuss on [this](https://etherscan.io/tx/0xab486012f21be741c9e674ffda227e30518e8a1e37a5f1d58d0b0d41f6e76530) transaction used to drain Fuse Pool 127.

## Exploit
A functional [PoC](https://github.com/papr1ka2/poc) of the hack.


# 1 Vulnerability
## 1.1 Background
The lending protocol is based on a fork of Compound. Each lending pool in Compound is implemented through a cToken smart contract. A cToken is ERC20 compatible. For Fuse pools they are implemented with an identical fToken contract. For convenience, we will use the term cToken, but it actually refers to fToken and is not related to Compound.

To give a clearer image of how this protocol is used, we will think of a situation where you want to borrow ETH. To borrow ETH you must provide collateral. Suppose we want to provide some USDC as collateral. Then we should deposit that USDC in the protocol by minting fUSDC, and this liquidity we have provided will become the collateral. We can then borrow ETH from the protocol using the fETH contract.

## 1.2 Re-entrancy
The core of the `borrow()` function is implemented in `borrowFresh()`. The `borrowFresh()` implementation does not follow the check-effect-interaction pattern, thus making it vulnerable to re-entrancy. Basic re-entrancy attacks were mitigated by a simple update, but this bug can be further exploited by using the `exitMarket()` function of the Comptroller contract. The `exitMarket()` function can be called for any cToken. When there is no loan taken for the underlying assets of that cToken, the underlying assets will no longer be considered as a collateral, thus making those assets withdrawable.

# 2 Exploitation
The exploit developed by us is consisted of two smart contracts that reproduce the [transaction](https://etherscan.io/tx/0xab486012f21be741c9e674ffda227e30518e8a1e37a5f1d58d0b0d41f6e76530) which targets the Fuse Pool 127. We configure hardhat to fork the Ethereum network at #14684810, just before the hack happened.

## 2.1 Overview
The basic idea is to mint cUSDC to provide collateral, borrow ETH, call `exitMarket()` for cUSDC, withdraw the USDC from the pool, transfer ETH out. This is done by simply calling `exitMarket()` within the fallback function. The reason it works is because when the fallback function is called to receive the borrowed ETH, the loan is not updated on the protocol.

The two contracts used to reproduce the attack are the Launcher contract and the Exploit contract.
The Launcher contract provides the initial liquidity via flash loan and retrieves the final profit.
The Exploit contract exploits the re-entrancy bug to transfer the ETH to the Launcher and withdraw USDC to payback the flash loan.

## 2.2 Providing liquidity via flash loan
To maximize the profit, we must maximize the amount of USDC we can provide as collateral. To do this, we borrow 150M USDC via flash loan from Balancer.
After deploying the Exploit contract, the Launcher contract initiates the flash loan and sends this large amount of liquidity to the Exploit contract.

## 2.3 Mint cUSDC
The Exploit contract mints cUSDC by first entering the market for cUSDC and depositing the 150M USDC received from the Launcher.

## 2.4 Borrow ETH
The cUSDC is then used to borrow the maximum amount of ETH (calculated by `getCash()`) from the fUSDC-127 (Fuse Pool 127) pool.

## 2.5 Redeem USDC
Within fallback function that is called when receiving the borrowed ETH, `exitMarket()` is called for cUSDC. Thus, after the fallback function returns the cUSDC is no longer considered as collateral and the exploit contract can redeem the underlying 150M USDC back from the pool.

## 2.6 Pay flash loan and transfer out ETH
After transferring out all the borrowed ETH, the exploit contract pays the flash loan with the redeemed USDC.

## 3 Conclusion
The same attack was repeated on many other pools causing catastrophic damage. Re-entrancy attacks have been here for a long time and proper mitigations are required.

## References
[Fei Rari - Rekt 2](https://rekt.news/fei-rari-rekt/)
[Peckshield - tweet](https://twitter.com/peckshield/status/1520369315698016256)