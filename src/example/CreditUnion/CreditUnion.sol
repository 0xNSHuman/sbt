// SPDX-License-Identifier: AGPL-3.0-or-later
pragma solidity ^0.8.13;

import "./ActiveLoan.sol";
import "./LoanRepayment.sol";

// An example of an on-chain entity utilizing the SBT primitives

contract CreditUnion {
	address public immutable loans;
	address public immutable loanRepayments;

	constructor(
		address loans_,
		address loanRepayments_
	) {
		loans = loans_;
		loanRepayments = loanRepayments_;
	}

	// I want to borrow 'amount' at a 'rate' that's acceptable to me
	function getLoan(uint256 amount, uint256 rate) external {
		// .. the Union performs check against my history of previous SBTs ..
		
		// If the loan is approved, the new SBT is issued
		ActiveLoan(loans).approve(msg.sender, amount, rate);
	}

	// A very simplified version of the use case
	function repayLoan(uint256 loanId) external {
		// Remove active loan record
		ISBT(loans).revoke(loanId);

		// Replace it with the loan repayment record
		LoanRepayment(loanRepayments).markAsPaid(loanId);
	}
}