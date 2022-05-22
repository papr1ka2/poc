pragma solidity ^0.5.16;

import "./interfaces/IFlashLoanRecipient.sol";

interface FlashLoans {
    function flashLoan(
        IFlashLoanRecipient recipient,
        IERC20[] calldata tokens,
        uint256[] calldata amounts,
        bytes calldata userData
    ) external;
}