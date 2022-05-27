// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// EIP-69420: A Dumbed-Down SBT Standard

interface ISBT {
	event Issue(address indexed issuer, address indexed holder, uint256 indexed tokenId);
	event Revoke(address indexed issuer, address indexed holder, uint256 indexed tokenId);
	event SetAttribute(address indexed issuer, uint256 indexed tokenId, uint8 attributeId, bytes32 value);

	function issuerOf(uint256 tokenId) external view returns (address);
	function holderOf(uint256 tokenId) external view returns (address);
	function attribute(uint256 tokenId, uint8 attributeId) external view returns (bytes32);

	function issue(address to, uint256 tokenId) external;
	function revoke(uint256 tokenId) external;
	function setAttribute(uint256 tokenId, uint8 attributeId, bytes32 value) external;
}