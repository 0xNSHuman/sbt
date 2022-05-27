// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../token/SBT/SBT.sol";

// An example of a concrete loan SBT.
// Attributes are encoded as enums for convenience.
// Off-chain data can be encrypted to enable privacy.

contract ActiveLoan is SBT {
	enum Attribute {
		Amount,
		Rate,
		OffchainURI
	}

	// Verrry unsafe counter
	uint256 private tokenId;

	constructor() SBT("Active Loan", "LOAN") { }

	function approve(address to, uint256 amount, uint256 rate) external {
		issue(to, tokenId);

		setAttribute(tokenId, uint8(Attribute.Amount), bytes32(amount));
		setAttribute(tokenId, uint8(Attribute.Rate), bytes32(rate));

		tokenId++; // Never do this in a real contract
	}
}

// ZK version of the SBT.
// The contract would host a specific zk-SNARK verification
// algorithm to prove that the soul met some minimal conditions
// that matter for other creditors, such as minimal borrowed 
// amount threshold, age or income of the borrower.
// All without revealing the exact details.

contract ActiveLoanZK is SBT {
	enum Attribute {
		AmountGreaterThan,
		MinAge,
		MinIncome
	}

	constructor() SBT("Active Loan Proof", "ZKLOAN") { }

	// zk-SNARK verification funtionality goes here..
}