// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721Metadata} from "@solidstate/contracts/token/ERC721/metadata/ERC721Metadata.sol";
import {ERC721MetadataStorage} from "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";

import {NFTGenerator} from "./libraries/NFTGenerator.sol";
import {TokenURIParams} from "./Types.sol";

/**
 * 1. Figure out the most optimized way of storing 5k genomes on chain, while reducing gas costs
 * 2. Implement a function to decode a genome, and return genome attributes
 * 3. Describe your thought process along the way of solving this problem
 */

contract GenomeNFT is ERC721Metadata {
  // keep token ID
  uint16 private tokenId;

  // keeping genome NFTs on chain
  // 5000 nfts so can use uint16
  mapping(uint16 => bytes) private genomeNfts;

  // event to get the newly minted token ID
  event GenomeNFTMinted(uint256 id);

  constructor(
    string memory tokenName,
    string memory tokenSymbol,
    string memory baseURI
  ) {
    // use storage slot to store metadata
    ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();
    l.name = tokenName;
    l.symbol = tokenSymbol;
    l.baseURI = baseURI;
  }

  function mint(
    address _address,
    string memory nftName,
    string memory description,
    TokenURIParams memory attributes
  ) external returns (uint16) {
    tokenId = tokenId + 1;

    // convert nft data to bytes
    genomeNfts[tokenId] = bytes(
      NFTGenerator.generate(nftName, description, attributes)
    );
    _mint(_address, tokenId);

    emit GenomeNFTMinted(tokenId);

    return tokenId;
  }

  function tokenURI(uint256 id) external view override returns (string memory) {
    return string(genomeNfts[uint16(id)]);
  }
}
