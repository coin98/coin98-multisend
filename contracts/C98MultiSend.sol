// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

import "./libraries/AdvancedVRC25.sol";

import "./VRC25.sol";

contract C98MultiSend is VRC25 {
    address eth_address = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;

    event transfer(address from, address to, uint amount, address tokenAddress);

    constructor() VRC25("MultiSend", "C98MS", 18) {}

    // Transfer multi main network coin
    // Example ETH, BSC, HT
    function transferMulti(address[] calldata receivers, uint256[] calldata amounts) public payable {
        require(msg.value != 0 && msg.value == getTotalSendingAmount(amounts));
        for (uint256 i = 0; i < amounts.length; i++) {
            payable(receivers[i]).transfer(amounts[i]);
            emit transfer(msg.sender, receivers[i], amounts[i], eth_address);
        }
    }

    // Transfer multi token VRC25
    function transferMultiToken(address tokenAddress, address[] calldata receivers, uint256[] calldata amounts) public {
        require(receivers.length == amounts.length && receivers.length != 0);

        for (uint i = 0; i < receivers.length; i++) {
            require(amounts[i] > 0 && receivers[i] != address(0));
            AdvancedVRC25.safeTransferFrom(tokenAddress, msg.sender, receivers[i], amounts[i]);

            emit transfer(msg.sender, receivers[i], amounts[i], tokenAddress);
        }
    }

    function getTotalSendingAmount(
        uint256[] calldata _amounts
    ) private pure returns (uint totalSendingAmount) {
        for (uint i = 0; i < _amounts.length; i++) {
            require(_amounts[i] > 0);
            totalSendingAmount += _amounts[i];
        }
    }

    // VRC25
    function _estimateFee(uint256) internal view virtual override returns (uint256) {
        return 0;
    }
}
