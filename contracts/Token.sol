// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

// in Contract modules for simple authorization and access control mechanisms.
import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TheProduct is Ownable{
	using SafeMath for uint; 

	address payable contractOwner;
	bool private stopped; //circuit breaker

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
	mapping(string => ProductSubmission) public productMap;

	/*
	a state variable to store an address corresponding to each product submission
	 */
	mapping(string => address) public productAddressMap;

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
		stopped = false;
	}

	/*
	circuit breaker switch
	 */
	function toggleContractActive() onlyOwner public returns(bool){
		stopped = !stopped;
		return stopped;
	}

	/*
	@dev circuit breaker modifier. Throws if contract is stopped
	 */
	modifier stopEmergency(){
		require(!stopped, "contract is currently stopped");
		_;
	}

	/*
	@dev register product submission 
	 */
	function registeredProductSubmission(
		string memory ProductHash,
		string memory ProductInfo,
		string memory SupplierDetails,
		string memory SubmissionDate)
	stopEmergency public returns(uint){
		// require(this.ProductSubmission(ProductHash) == false, "Error: product already submitted.");

		// uint256 SubmissionBlockNumber = block.number;
		// uint256 isSet = 1;

		// productMap(ProductHash) = ProductSubmission(
		// 	ProductHash, 
		// 	ProductInfo, 
		// 	SupplierDetails, 
		// 	SubmissionDate,
	 //        SubmissionBlockNumber, 
	 //        isSet);

		/*
		map producthash & product submitter then save in storage
		 */
		// productAddressMap[ProductHash] = msg.sender;

		/*
		add the producthash to the array for length tracking
		 */
		// uint id = productHashes.push(ProductHash);
		// id = id.sub(1);

		// emit registeredProductEvent(id);
		// return id;
	}
}