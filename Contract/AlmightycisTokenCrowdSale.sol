// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ACTCrowdsale is Ownable {
    ERC20 public token;
    uint256 public rate = 1000;
    bool public isCrowdsaleOpen = true;
    uint256 public constant MIN_ETH_AMOUNT = 0.1 ether;
    uint256 public constant MAX_ETH_AMOUNT = 1000 ether;

    event TokensPurchased(address indexed buyer, uint256 amount);
    event TokensRetrieved(address indexed owner, uint256 amount);

    constructor(ERC20 _token) {
        token = _token;
    }

    receive() external payable {
        require(isCrowdsaleOpen, "Crowdsale is closed");
        require(msg.value >= MIN_ETH_AMOUNT, "Amount sent is below minimum(0.1eth)");
        require(msg.value <= MAX_ETH_AMOUNT, "Amount sent is above maximum(1000eth)");

        uint256 tokenAmount = msg.value * rate;

        token.transfer(msg.sender, tokenAmount);

        emit TokensPurchased(msg.sender, tokenAmount);

        payable(owner()).transfer(msg.value);
    }    

    function endCrowdsale() public onlyOwner {
        isCrowdsaleOpen = false;
    }

    function openCrowdsale() public onlyOwner {
        isCrowdsaleOpen = true;
    }

    function ethwithdraw() public onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function retrieveTokens(uint256 amount) public onlyOwner {
        token.transfer(msg.sender, amount);
    }
}
