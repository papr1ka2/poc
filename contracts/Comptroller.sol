pragma solidity ^0.5.16;

import "./interfaces/ComptrollerInterface.sol";
import "./ComptrollerStorage.sol";

contract Comptroller is ComptrollerV3Storage, ComptrollerInterface {
	function getAccountLiquidity(address account) public view returns (uint, uint, uint);
}
