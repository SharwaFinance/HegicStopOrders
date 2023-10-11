// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.0;

import { IERC721 } from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol"; // Import ERC721Receiver

interface IPositionsManager is IERC721 {
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
    function nextTokenId() external view returns (uint256);
}

contract MockPositionsManager is IPositionsManager {
    mapping(uint256 => address) private _owners;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    bytes4 private constant _ERC721_RECEIVED = 0x150b7a02; // Define ERC721_RECEIVED
    uint256 private _nextTokenId = 1;

    function mint(address to) external {
        uint256 tokenId = _nextTokenId;
        _owners[tokenId] = to;
        _nextTokenId++;
        emit Transfer(address(0), to, tokenId);
    }

    function approve(address to, uint256 tokenId) external override {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Not approved");
        _tokenApprovals[tokenId] = to;
        emit Approval(owner, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public override {
        address owner = ownerOf(tokenId);
        require(msg.sender == owner || getApproved(tokenId) == msg.sender || isApprovedForAll(owner, msg.sender), "Transfer not approved");
        require(owner == from, "Not the token owner");
        _owners[tokenId] = to;
        emit Transfer(from, to, tokenId);
    }

    function ownerOf(uint256 tokenId) public view override returns (address) {
        return _owners[tokenId];
    }

    function getApproved(uint256 tokenId) public view override returns (address) {
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view override returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function setApprovalForAll(address operator, bool approved) external override {
        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) external view override returns (bool) {
        address owner = ownerOf(tokenId);
        return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
    }

    function nextTokenId() external view override returns (uint256) {
        return _nextTokenId;
    }

    function balanceOf(address owner) external override view returns (uint256 balance) {}

    function safeTransferFrom(address from, address to, uint256 tokenId) external override {}

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external override {}

    function supportsInterface(bytes4 interfaceId) external override view returns (bool) {}

}
