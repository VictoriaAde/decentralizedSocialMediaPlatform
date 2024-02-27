// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

interface ISocialMedia {
       enum UserRole {
        Admin,
        Moderator,
        User
    }

    function registerUser(string memory _name, string memory _symbol, UserRole _role) external; 

    function createPost(string memory _uri, string memory _caption) external;

}