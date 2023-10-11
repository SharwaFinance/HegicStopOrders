// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.0;

import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface IPositionsManager is IERC721 {
    function isApprovedOrOwner(address spender, uint256 tokenId) external view returns (bool);
    function nextTokenId() external view returns (uint256);
}