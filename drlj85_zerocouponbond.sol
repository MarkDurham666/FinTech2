// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ZeroCouponBond {
    uint256 public constant FACE_VALUE = 0.1 ether;
    uint256 public constant DISCOUNT_RATE = 20;  // 20%
    uint256 public constant ISSUE_PRICE = FACE_VALUE * (100 - DISCOUNT_RATE) / 100;
    uint256 public maturityBlock;
    mapping(address => uint256) public balances;

    // Events
    event Purchased(address indexed buyer, uint256 amount);
    event Redeemed(address indexed redeemer, uint256 amount);
    event Transferred(address indexed from, address indexed to, uint256 amount);

    constructor() {
        maturityBlock = block.number + 10000;  // Set maturity block at deployment
    }

    function buy(uint256 numBonds) external payable {
        require(msg.value == ISSUE_PRICE * numBonds, "Incorrect ETH amount sent");
        balances[msg.sender] += numBonds;
        emit Purchased(msg.sender, numBonds);
    }

    function redeem() external {
        require(block.number >= maturityBlock, "Bond not yet matured");
        uint256 amount = balances[msg.sender];
        require(amount > 0, "No bonds to redeem");
        uint256 redeemValue = amount * FACE_VALUE;
        balances[msg.sender] = 0;  // Zero the balance before transferring to prevent re-entrancy attacks
        payable(msg.sender).transfer(redeemValue);
        emit Redeemed(msg.sender, amount);
    }

    function transfer(address to, uint256 amount) external {
        require(balances[msg.sender] >= amount, "Insufficient balance");
        require(to != address(0), "Cannot transfer to the zero address");
        balances[msg.sender] -= amount;
        balances[to] += amount;
        emit Transferred(msg.sender, to, amount);
    }
}


