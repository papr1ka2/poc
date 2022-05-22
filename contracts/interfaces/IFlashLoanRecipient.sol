pragma solidity ^0.5.16;

import "./IERC20.sol";

interface IFlashLoanRecipient {
    function receiveFlashLoan(
        IERC20[] calldata tokens,
        uint256[] calldata amounts,
        uint256[] calldata feeAmounts,
        bytes calldata userData
    ) external;
}