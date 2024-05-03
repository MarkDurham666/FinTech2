// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MyToken is ERC20 {
    constructor() ERC20("1197_FinTech2", "1197FT2") {
        _mint(msg.sender, 1000 * (10 ** uint256(decimals())));
    }
}

