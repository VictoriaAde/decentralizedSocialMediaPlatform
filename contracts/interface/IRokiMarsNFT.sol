// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface IRokiMarsNFT {
        function safeMint(address to, string memory uri) external returns (uint256);
}