pragma solidity ^0.5.16;

import "./CToken.sol";

contract ComptrollerV2Storage {
    mapping(address => CToken) public cTokensByUnderlying;
}

contract ComptrollerV3Storage is ComptrollerV2Storage {
}
