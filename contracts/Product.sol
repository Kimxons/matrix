// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.6.0;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./Registrations.sol";
import "./Token/ERC20.sol";

contract Product is Context, Ownable{
	using SafeMath for uint; 
	address payable contractOwner;
    bool private stopped; // for use in circuit breaker

    Registrations private registrations;
    
    //identifiers  
    bytes32 OrderId;
    address public buyer;
    address public seller; //supplier(farmer)
    bytes32 deliveryDate;
    bytes32 paymentDate;
    uint256 orderAmount;
    bytes32[50] orderDetails;
    
    bool approvalSeller;
    bool approvalBuyer;
    bool orderCompletion;   
    
    // a dynamically sized array of suppliers
    address[] suppliers; //sellers (farmers)

    /**
    * a struct acts as a loose bag of variables
    */
	struct ProductSubmission{
		string ProductHash;
		string ProductInfo;
		string SupplierDetails;
		string SubmissionDate;
		uint256 BlockNumber;
		uint isSet; 
	}
	
	modifier checkUser(address _address) {
        require(registrations.isRegistered(_address), "Access Denied");
        _;
    }
    modifier onlyOnNum(uint256 num) {
        require(num != 0, "Value not set");
        _;
    }

    modifier onlyOnSuppliers {
        require(suppliers.length != 0, "There are no suppliers");
        _;
    }
    modifier onSellerTrue() {
        require(approvalSeller == true, "Seller hasn't agreed");

        _;
    }
    modifier onBuyerTrue() {
        require(approvalSeller == true, "Seller hasn't agreed");

        _;
    }
    modifier onlyOnSetAddress(address check) {
        require(check != address(0), "Value not yet set");
        _;
    }

    modifier onlyOnString(bytes32 str) {
        require(str.length != 0, "There are no suppliers");
        _;
    }
    modifier onStringNull(bytes32 str) {
        require(str.length == 0, "Value has already been set");
        _;
    }
    modifier onUserNull(address user) {
        require(user == address(0), "Value already set");
        _;
    }

    modifier onBoolNull(bool val) {
        require(val == false, "Value already set");
        _;
    }
    modifier onNumNull(uint256 num) {
        require(num == 0, "Value has already been set");
        _;
    }

    modifier checkOrderCompletion(bool _orderCompletion) {
        require(_orderCompletion == true, "Order has to be completed");
        _;
    }
    function setOrderAmt(uint256 _orderAmt) public onNumNull(orderAmount) {
        orderAmount = _orderAmt;
    }
    function setOrderDetails(bytes32[50] memory _msg) public {
        orderDetails = _msg;
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

	function registerProductSubmission(string memory ProductHash)
    stopInEmergency public view returns(uint){
        require(this.checkProductSubmission(ProductHash) == false, "Error: Product already uploaded.");
        uint256 Blocknumber = block.number;
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

    function destroy() public onlyOwner onlyInEmergency {
        // cast owner which is address to address payable
        selfdestruct(contractOwner);
    }

    function setOrderCompletion(bool _orderCompletion) public
        onSellerTrue
        onBuyerTrue
        onlyOnOrderDetails
        onBoolNull(orderCompletion){
        orderCompletion = _orderCompletion;
    }

    function setBuyer(address _buyer) public
        onUserNull(buyer)
        checkUser(_buyer){
        buyer = _buyer;
    }

    function getBuyer() public view onlyOnSetAddress(buyer) returns (address) {
        return buyer;
    }

    function getSeller() public view
        onlyOnSetAddress(seller)
        returns (address) {
            return seller;
    }

    function getSuppliers() public view
        onlyOnSuppliers
        onBuyerTrue
        onSellerTrue
        returns (address[] memory){
            return suppliers;
    }

    function getDeliveryDate() public view
        onlyOnString(deliveryDate)
        returns (bytes32) {
            return deliveryDate;
    }

    function getPaymentDate() public view
        onlyOnString(paymentDate)
        returns (bytes32) {
            return paymentDate;
    }

    function getOrderAmt() public view returns (uint256) {
        return orderAmount;
    }
    modifier onlyOnOrderDetails() {
        require(orderDetails.length != 0, "Order Details not set");
        _;
    }
    function getOrderDetails() public view
        onlyOnOrderDetails
        returns (bytes32[50] memory){
        return orderDetails;
    }

    function getApprovalSeller() public view returns (bool) {
        return approvalSeller;
    }

    function getBuyerApproval() public view returns (bool) {
        return approvalBuyer;
    }

    function setSeller(address _seller) public
        onUserNull(seller)
        checkUser(_seller){
            seller = _seller;
    }

    function setApprovalSeller(bool _approvalSeller) public
        onlyOnString(deliveryDate)
        onlyOnString(paymentDate)
        onlyOnOrderDetails
        onBoolNull(approvalSeller)
        onlyOnNum(orderAmount){
            approvalSeller = _approvalSeller;
    }

    function setApprovalBuyer(bool _approvalBuyer) public
        onSellerTrue
        onBoolNull(approvalBuyer){
            approvalBuyer = _approvalBuyer;
    }
}