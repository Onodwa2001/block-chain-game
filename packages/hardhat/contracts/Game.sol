pragma solidity ^0.8.9;

contract DailyGames {
    address public owner;
    uint256 public endTime;
    uint256 public winningAmount;
    
    struct Player {
        uint256 points;
        bool exists;
        address walletAddress;
    }
    
    mapping(address => Player) public players;
    address[] public playerAddresses;
    
    event NewPlayer(address player);
    event PointsAdded(address player, uint256 points);
    event WinnerDeclared(address winner, uint256 points, uint256 amountWon);
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
    
    modifier beforeEndTime() {
        require(block.timestamp < endTime, "The game has ended");
        _;
    }
    
    constructor(uint256 _durationHours, uint256 _winningAmount) {
        owner = msg.sender;
        endTime = block.timestamp + (_durationHours * 1 hours);
        winningAmount = _winningAmount;
    }
    
    function addPoints(uint256 _points) public beforeEndTime {
        if (!players[msg.sender].exists) {
            players[msg.sender] = Player(_points, true, msg.sender);
            playerAddresses.push(msg.sender);
            emit NewPlayer(msg.sender);
        } else {
            players[msg.sender].points += _points;
        }
        emit PointsAdded(msg.sender, _points);
    }
    
    function declareWinner() public onlyOwner {
        require(block.timestamp >= endTime, "The game has not ended yet");
        address winner;
        uint256 highestPoints = 0;
        for (uint256 i = 0; i < playerAddresses.length; i++) {
            address playerAddress = playerAddresses[i];
            if (players[playerAddress].points > highestPoints) {
                highestPoints = players[playerAddress].points;
                winner = playerAddress;
            }
        }
        require(winner != address(0), "No players participated");
        uint256 amountWon = winningAmount;
        payable(winner).transfer(amountWon);
        emit WinnerDeclared(winner, highestPoints, amountWon);
    }
    
    // Allow the owner to withdraw any remaining funds in the contract
    function withdraw() public onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }

    // Function to submit the wallet address
    function submitAddress(address _walletAddress) public {
        require(!players[msg.sender].exists, "Address already submitted");
        players[msg.sender] = Player(0, true, _walletAddress);
        playerAddresses.push(msg.sender);
        emit NewPlayer(msg.sender);
    }
    
    // Fallback function to receive ETH
    receive() external payable {}

    // View function to get the list of participant addresses
    function getParticipants() public view returns (address[] memory) {
        return playerAddresses;
    }
}
