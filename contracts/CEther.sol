pragma solidity ^0.5.16;

import "./CToken.sol";
import "./interfaces/CTokenInterfaces.sol";

contract CEther is CToken {
    function borrow(uint borrowAmount) external returns (uint);
}
