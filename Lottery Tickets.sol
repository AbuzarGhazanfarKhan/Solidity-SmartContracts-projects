// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <=0.9.0;

contract Lottery{

    address public manager;
    address payable[] public players;

    constructor(){
        manager=msg.sender;
    }
    function alreadyEntered() view private returns(bool){
        for(uint i=0; i<=players.length;i++){
            if(players[i]==msg.sender){
                return true;
            }
        }
        return false;
    }


    function enterLottery() payable public{
        require(msg.sender != manager,"MANAGER CANNOT PLAY LOTTERY");
        require(alreadyEntered() == false,"Player is already playing lottery");
        players.push(payable(msg.sender));
    }

    function random() view private returns(uint) {
return uint(sha256(abi.encodePacked(block.difficulty,block.number,players)));

    }
    function pickWinner() public{

        require(msg.sender == manager,"manager only");
       uint index= random() % players.length;//Index of the winenr in playes array
      address contractAddress=address(this);
      players[index].transfer(contractAddress.balance);
      players=new address payable[](0);
    }

    function getPlayers() view public returns(address payable[] memory){
        return players;
    }
}