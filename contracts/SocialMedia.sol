// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./RokiMarsNFT.sol";

contract SocialMedia {
    mapping(uint256 => bool) public isPostApproved;
    mapping(address => UserRole) private userRoles;
    mapping(address => address) private userNftContracts;
    mapping(uint256 => string[]) public postComments;
    mapping(uint256 => Post) public posts;

    event PostCreated(address indexed creator, uint256 indexed tokenId, string uri);
    event PostApproved(address indexed approver, uint256 indexed tokenId);
    event CommentAdded(address indexed commenter, uint256 indexed tokenId, string comment);

    constructor() {
        userRoles[msg.sender] = UserRole.Admin;
        admins.push(msg.sender);
    }

    struct Post {
        uint256 tokenId;
        string uri;
        string caption;
    }

    enum UserRole { 
        Admin, 
        User, 
        Moderator 
    }

    address[] private admins;
    address[] private users;
    address[] private moderators;

    function registerUser(string memory _name, string memory _symbol, UserRole _role) external {
        if (_role == UserRole.Admin) {
            admins.push(msg.sender);
        } else if (_role == UserRole.User) {
            users.push(msg.sender);
        } else if (_role == UserRole.Moderator) {
            moderators.push(msg.sender);
        }
        userRoles[msg.sender] = _role;

        // Deploy a new NFT contract for the user with their specified name and symbol
        RokiMarsNFT _newNftContract = new RokiMarsNFT(msg.sender, _name, _symbol);
        userNftContracts[msg.sender] = address(_newNftContract);
    }


    function createPost(string memory _uri, string memory _caption) external {
        require(userRoles[msg.sender] == UserRole.Admin || userRoles[msg.sender] == UserRole.Moderator || userRoles[msg.sender] == UserRole.User, "User is not authenticated");

        RokiMarsNFT _userNftContract = RokiMarsNFT(userNftContracts[msg.sender]);
        uint256 _tokenId = _userNftContract.safeMint(msg.sender, _uri); 

        posts[_tokenId] = Post(_tokenId, _uri, _caption);

        emit PostCreated(msg.sender, _tokenId, _uri);
    }

    function commentOnPost(uint256 tokenId, string memory comment) external {
        require(isPostApproved[tokenId], "Post is not approved");
        postComments[tokenId].push(comment);

        emit CommentAdded(msg.sender, tokenId, comment);
    }

    function approvePost(uint256 _tokenId) external {
        require(userRoles[msg.sender] == UserRole.Moderator || userRoles[msg.sender] == UserRole.Admin, "Caller is not a moderator or an admin");
        require(!isPostApproved[_tokenId], "Post has already been approved");
        require(posts[_tokenId].tokenId !=  0, "Post does not exist");

        isPostApproved[_tokenId] = true;

        emit PostApproved(msg.sender, _tokenId);
    }

    function updateRole(address user, UserRole role) external {
        require(userRoles[msg.sender] == UserRole.Admin, "Caller is not an admin");
        require(userRoles[user] != UserRole.Admin, "User is not registered");
        
        // Update the user's role
        userRoles[user] = role;
    }

    function getAdmins() external view returns (address[] memory) {
        return admins;
    }

    function getUsers() external view returns (address[] memory) {
        return users;
    }

    function getModerators() external view returns (address[] memory) {
        return moderators;
    }
}
