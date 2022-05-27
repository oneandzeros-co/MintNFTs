//SPDX-License-Identifier: MIT

pragma solidity ^ 0.8.1;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/security/PullPayment.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Minty is ERC721, PullPayment, Ownable {
    using Counters for Counters.Counter;

    uint256 public constant MINT_PRICE = 0.08 ether;

    Counters.Counter private currentTokenId;

    /// @dev Base token URI used as a prefix by tokenURI().
    string public baseTokenURI;
    
    mapping(uint256 => string) private _tokenURIs;
    constructor(string memory tokenName, string memory symbol) ERC721(tokenName, symbol) {
        baseTokenURI = "ipfs://";
    }

    function mintToken(address owner, string memory metadataURI)
    public payable returns(uint256) {
        require(msg.value == MINT_PRICE, "Transaction value did not equal the mint price");
        currentTokenId.increment();
        uint256 id = currentTokenId.current();
        _safeMint(owner, id);
        _setTokenURI(id, metadataURI);
        return id;
    }

    function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
        require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
        _tokenURIs[tokenId] = _tokenURI;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns(string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory _tokenURI = _tokenURIs[tokenId];
        string memory base = _baseURI();
        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId));
    }
    
    /// @dev Returns an URI for a given token ID
    function _baseURI() internal view virtual override returns(string memory) {
        return baseTokenURI;
    }

    /// @dev Sets the base token URI prefix.
    function setBaseTokenURI(string memory _baseTokenURI) public onlyOwner {
        baseTokenURI = _baseTokenURI;
    }

    /// @dev Overridden in order to make it an onlyOwner function
    function withdrawPayments(address payable payee) public override onlyOwner virtual {
      (bool os, ) = payable(owner()).call{value: address(this).balance}("");
      require(os);
      super.withdrawPayments(payee);
  }
}