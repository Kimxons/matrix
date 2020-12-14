// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Product is Ownable{
	using SafeMath for uint; 

	address payable contractOwner;
    bool private stopped; // for use in circuit breaker

	struct ProductSubmission{
		string ProductHash;
		string ProductInfo;
		string SupplierDetails;
		string SubmissionDate;
		uint256 BlockNumber;
		uint isSet; 
	}

	/*
	state variable to store a ProductSubmission struct for each possible product hash
	 */
	mapping(string => ProductSubmission) public productsMap;

	/*
	a state variable to store an address corresponding to each product submission
	 */
	mapping(string => address) public productsAddressMap;

	/*
	a dynamically-sized array containing product hashes
	 */
	string[] public productHashes;

	/*
	@dev fired on submission of a product
	 */
	event registeredProductEvent(uint indexed _productSubmissionId);

	/*
	@dev Constructor
	 */
	constructor() public{
		contractOwner = msg.sender;
	}

	 /*
        @dev Circuit breaker switch
    */
    function toggleContractActive() onlyOwner public returns (bool) {
        stopped = !stopped;
        return stopped;
    }

    /*
        @dev Circuit breaker modifier. Throws if contract is stopped.
    */
    modifier stopInEmergency() {
        require(!stopped, "Contract is currently stopped.");
        _;
    }

    /*
        @dev Circuit breaker modifier. Throws if contract is not stopped.
    */
    modifier onlyInEmergency() {
        require(stopped, "Contract is not currently stopped.");
        _;
    }

	function registerProductSubmission(
		string memory ProductHash
		) 

		stopInEmergency public view returns(uint){

			require(this.checkProductSubmission(ProductHash) == false, "Error: Product already uploaded.");

	        uint256 SubmissionBlocknumber = block.number;
	        uint256 IsSet = 1;
		}

	function checkProductSubmission(string memory hash) 
	public stopInEmergency view returns (bool) {
        // check whether the hash is among the list of known hashes
        uint onChainIsSet = productsMap[hash].isSet;
        if (onChainIsSet > 0) {
            // if yes, return true
            return true;
          }
        // otherwise return false
        return false;
    }
    /**
     * @dev Confirm whether the contract is stopped or not.
     */
    function checkContractIsRunning() public view returns (bool) {
        return stopped;
    }

	/*
	 @dev fallback function. This gets executed if a transaction with invalid data is sent to the contract or
     *   just ether without data. We revert the send so that no-one accidentally loses money when using the contract.
	 */

	// function() external {
 //        revert();
 //    }

    function destroy() public onlyOwner onlyInEmergency {
        // cast owner which is address to address payable
        selfdestruct(contractOwner);
    }
}