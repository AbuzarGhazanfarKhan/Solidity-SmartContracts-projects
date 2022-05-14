// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

contract RentABike {

    address owner;

    constructor() {
        owner = msg.sender;
    }

    // Add yourself as a Renter

    struct Renter {
        address payable walletAddress;
        string firstName;
        string lastName;
        bool canRent;
        bool active;
        uint balance;
        uint due;
        uint startTime;
        uint endTime;
    }

    mapping (address => Renter) public renters;

    function addRenter(address payable walletAddress, string memory firstName, string memory lastName, bool canRent, bool active, uint balance, uint due, uint startTime, uint endTime) public {
        renters[walletAddress] = Renter(walletAddress, firstName, lastName, canRent, active, balance, due, startTime, endTime);
    }

    // Checkout bike
    function checkOut(address walletAddress) public {
        require(renters[walletAddress].due == 0, "You have a pending balance.");
        require(renters[walletAddress].canRent == true, "You cannot rent at this time.");
        renters[walletAddress].active = true;
        renters[walletAddress].startTime = block.timestamp;
        renters[walletAddress].canRent = false;
    }

    // Check in a bike
    function checkIn(address walletAddress) public {
        require(renters[walletAddress].active == true, "Please check out a bike first.");
        renters[walletAddress].active = false;
        renters[walletAddress].endTime = block.timestamp;
        setDue(walletAddress);
    }

    // Get total duration of bike use
    function renterTimespan(uint startTime, uint endTime) internal pure returns(uint) {
        return endTime - startTime;
    }

    function getTotalDuration(address walletAddress) public view returns(uint) {
        require(renters[walletAddress].active == false, "Bike is currently checked out.");
        uint timespan = renterTimespan(renters[walletAddress].startTime, renters[walletAddress].endTime);
        uint timespanInMinutes = timespan / 60;
        return timespanInMinutes;
    }

    // Get Contract balance
    function balanceOf() view public returns(uint) {
        return address(this).balance;
    }

    // Get Renter's balance
    function balanceOfRenter(address walletAddress) public view returns(uint) {
        return renters[walletAddress].balance;
    }

    // Set Due amount
    function setDue(address walletAddress) internal {
        uint timespanMinutes = getTotalDuration(walletAddress);
        uint fiveMinuteIncrements = timespanMinutes / 5;
        renters[walletAddress].due = fiveMinuteIncrements * 5000000000000000;
    }

    function canRentBike(address walletAddress) public view returns(bool) {
        return renters[walletAddress].canRent;
    }

    // Deposit
    function deposit(address walletAddress) payable public {
        renters[walletAddress].balance += msg.value;
    }

    // Make Payment
    function makePayment(address walletAddress) payable public {
        require(renters[walletAddress].due > 0, "You do not have anything due at this time.");
        require(renters[walletAddress].balance > msg.value, "You do not have enough funds to cover payment. Please make a deposit.");
        renters[walletAddress].balance -= msg.value;
        renters[walletAddress].canRent = true;
        renters[walletAddress].due = 0;
        renters[walletAddress].startTime = 0;
        renters[walletAddress].endTime = 0;
    }

}