// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../../token/SBT/ISBT.sol";
import "../../token/SBT/SBT.sol";

// An example of a concrete loan repayment SBT.
// This contract works with the specific loan SBT only.

contract LoanRepayment is SBT {
	enum Attribute {
		LoanID
	}

	// Verrry unsafe counter
	uint256 private tokenId;
	address private loans;

	constructor(
		address loans_
	) SBT("Loan Repayment", "PAID") { 
		loans = loans_;
	}

	function markAsPaid(uint256 loanId) external {
		address holder = ISBT(loans).holderOf(loanId);

		issue(holder, tokenId);

		setAttribute(tokenId, uint8(Attribute.LoanID), bytes32(loanId));

		tokenId++; // Never do this in a real contract
	}
}

// ZK version of the SBT.
// The contract would host a specific zk-SNARK verification
// algorithm to prove that the soul met some minimal conditions
// that matter for other creditors, such as minimal borrowed 
// amount threshold, age or income of the borrower.
// All without revealing the exact details.

contract LoanRepaymentZK is SBT {
	enum Attribute {
		AmountGreaterThan,
		MinAge,
		MinIncome
	}

	constructor() SBT("Loan Repayment Proof", "ZKPAID") { }

	// zk-SNARK verification funtionality goes here..
}