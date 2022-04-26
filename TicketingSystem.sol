// SPDX-License-Identifier: MIT

pragma solidity <=0.8.0;

contract TicketingSystem{
    mapping (address => uint) public ticketHolder;
    uint ticketPrice=0.01 ether;
    address owner;

    constructor(){
        owner=msg.sender;
    }



    function buyTickets(address _user, uint _amount) payable public{
        require(msg.value >= ticketPrice*_amount);
        addTicket(_user,_amount);
    }
    function useTickets(address payable _user, uint _amount) public{
        cancelTickets(_user,_amount);
    }

    function addTicket(address _user, uint _amount) internal{
        ticketHolder[_user]=ticketHolder[_user] +_amount;

    }

    function cancelTickets(address payable _user, uint _amount) internal{
        require(ticketHolder[_user]>= _amount,"You do not have enough tickets to cancel");
         ticketHolder[_user]=ticketHolder[_user] -_amount;
         _user.transfer( _amount);
    }
    function withdraw() public {
        require(msg.sender == owner,"Authorised indivisuals only");
       (bool success, ) = payable(owner).call{value:address(this).balance}("");
       require(success);
    }
}