// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ISBT.sol";

// Quick-n-dirty example of EIP-69420 implementation.
// Untested and never used! Don't use it as is or you'll get rekt.

contract SBT is ISBT {
	// The boring stuff similar to the established token standards
	// with the non-transferability twist. Just here for context..
	string private name;
	string private symbol;
	mapping(uint256 => address) private issuers;
	mapping(uint256 => address) private holders;
	// ..etc..

	// Attribute storage indexed as TOKEN_ID => ATTRIBUTE_ID => ATTRIBUTE_VALUE
	mapping(uint256 => mapping(uint8 => bytes32)) public attributes;

	// We can get creative here and have a whitelist of addresses
	// instead of limiting it to just one issuer.
	error NotIssuer();
	modifier issuerOnly(uint256 tokenId) {
		if (msg.sender == issuers[tokenId]) {
			revert NotIssuer();
		}

		_;
	}

	constructor(
		string memory name_, 
		string memory symbol_
	) {
        name = name_;
        symbol = symbol_;
    }

	// Anyone can query the public values

	function issuerOf(uint256 tokenId) external view returns (address) {
		return issuers[tokenId];
	}

	function holderOf(uint256 tokenId) external view returns (address) {
		return holders[tokenId];
	}
	
	/**
		Takes the token ID and pre-defined attribute ID as parameters.
		
		Returns a 32-byte value that can be decoded as a number, string, byte array etc. 
		If the value is of a dynamic length (longer than 32 bytes) — this can be a pointer 
		to another custom data structure.

		The attribute storage is limited to 1 byte per key and 32 bytes per value for efficiency.
	 */
	function attribute(uint256 tokenId, uint8 attributeId) public virtual view returns (bytes32) {
		return attributes[tokenId][attributeId];
	}

	// The token is non-transferrable after being issued.
	// Arguably, attributes are better be initialized during this transaction
	// as an atomic event, but this is outside the scope of this demo.
	function issue(address to, uint256 tokenId) public virtual {
		issuers[tokenId] = msg.sender;
		holders[tokenId] = to;

		emit Issue(msg.sender, to, tokenId);
	}

	// Only the issuer can revoke the token (non-revokable implementation possible)
	function revoke(uint256 tokenId) public virtual issuerOnly(tokenId) {
		// Firing event before mutation to save a memory allocation
		emit Revoke(msg.sender, holders[tokenId], tokenId);

		delete issuers[tokenId];
		delete holders[tokenId];

		// Let's leave the attributes history there, 
		// so that terminated votes are still persisted.
	}

	// Only the issuer can set the token's attributes
	function setAttribute(uint256 tokenId, uint8 attributeId, bytes32 value) public virtual issuerOnly(tokenId) {
		attributes[tokenId][attributeId] = value;

		emit SetAttribute(msg.sender, tokenId, attributeId, value);
	}
}