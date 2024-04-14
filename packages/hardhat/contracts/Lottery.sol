//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


contract Lottery {
    address public manager;
    uint256 public ticketPrice;
    bool public isOpened;
    address public winner;

    address[] public players;

    constructor () {
        manager = msg.sender;
        ticketPrice = 1 ether;
        isOpened = true;
    }

    function playLottery() public payable returns(bool) {
        require(msg.value == ticketPrice, "Invalid Bet Price");
        players.push(msg.sender);        
        return true;

    }
    function getRandomNumber() internal view returns(uint256 randomNumber) {
        randomNumber = block.timestamp;
    }
    function openLottery() public  returns(bool) {
        isOpened = true;
        return isOpened;
    }
    function CloseLottery() public returns(bool){
        require(isOpened == true, "Already closed!");
         uint256 winnerIndex = getRandomNumber() % players.length;
         address lotteryWinner = players[winnerIndex];
         winner = lotteryWinner;
         uint256 pool = address(this).balance;
        payable(lotteryWinner).transfer(pool);
        isOpened = false;
        return true;


    }
    function getNumberOfPlayers() public view returns(uint){
        return players.length;
    }

   function getLotteryBalance() public view returns(uint256) {
       return address(this).balance;
   }

}