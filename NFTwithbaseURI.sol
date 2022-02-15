// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract youbayNFT is ERC721, AccessControl { 
        using Strings for uint256;
        using Counters for Counters.Counter;
        
        bytes32 public constant ADMIN_ROLE = keccak256("ADMIN_ROLE");
        bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

        // Base URI
        string private _baseUriExtended;
        Counters.Counter private _tokenIds;
    
        
        constructor() ERC721("FUNNY GOAT NFT", "FG") {
            _baseUriExtended = "www.google.com/";
            _setupRole(ADMIN_ROLE, msg.sender);
            _setupRole(MINTER_ROLE, msg.sender);
        }

        // mint Non-Fungile Function
        function mintNFT() external {
            require(hasRole(MINTER_ROLE, msg.sender), "not authorized");
         
            _tokenIds.increment(); 
            uint256 tokenId = _tokenIds.current();
            _mint(msg.sender, tokenId);
        }
        
        function setBaseURI(string memory baseURI_) external {
            require(hasRole(ADMIN_ROLE, msg.sender), "Admin only");
            require(bytes(baseURI_).length > 0, "Cannot be null");

            _baseUriExtended = baseURI_;
        }

        function baseURI() public view returns (string memory) {
            return _baseUriExtended; 
        }
        
  //      function setWhitelistAddress(address[] memory addresses) external {
  //          require(hasRole(ADMIN_ROLE, msg.sender), "Admin only");
   //         for (uint i = 0; i < addresses.length; i++) {
  //              _setupRole(MINTER_ROLE, addresses[i]);
   //         }
   //     }

        function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
        )  internal virtual override {
            super._beforeTokenTransfer(from, to, tokenId);
        }

        function tokenURI(uint256 tokenId) public view override returns (string memory) {
            require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");    
            return string(abi.encodePacked(baseURI(), tokenId.toString()));
        }
    
        function supportsInterface(bytes4 interfaceId) public view virtual 
            override(AccessControl, ERC721) returns (bool) {
            return super.supportsInterface(interfaceId);
        }

        function getCurrentTokenId() public view returns (uint256) {
            return _tokenIds.current();
        }
}
