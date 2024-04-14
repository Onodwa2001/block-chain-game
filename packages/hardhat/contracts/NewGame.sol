pragma solidity ^0.8.9;

contract DailyGame {
    address public owner;
    uint256 public constant SCORE_MULTIPLIER = 10000;
    uint256 public constant CELLO_PER_POINT = 0.00001 * (10**18); // Convert to wei

    event Payment(address indexed receiver, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function payUser(address _user, uint256 _score) external {
        uint256 paymentAmount = _score * SCORE_MULTIPLIER * CELLO_PER_POINT;
        payable(_user).transfer(paymentAmount);
        emit Payment(_user, paymentAmount);
    }

    // Allow the owner to withdraw any remaining funds in the contract
    function withdraw() external onlyOwner {
        uint256 contractBalance = address(this).balance;
        payable(owner).transfer(contractBalance);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}
