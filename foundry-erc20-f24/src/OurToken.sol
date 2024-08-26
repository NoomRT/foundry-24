// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

error OurToken__OnlyOwer();

contract OurToken is ERC20 {

    address private immutable i_owner;

    constructor(uint256 initialSupply) ERC20("OurToken", "OT") {
        i_owner = msg.sender;
        _mint(msg.sender, initialSupply);
    }

    modifier OnlyOwner() {
        if(msg.sender != i_owner) {
            revert OurToken__OnlyOwer();
        }
        _;
    }

    function mint(address account, uint256 value) external OnlyOwner {
        _mint(account, value);
    }

    function burn(address account, uint256 value) external OnlyOwner {
        _burn(account, value);
    }
}
