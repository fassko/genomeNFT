// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721MetadataStorage} from "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";
import {ERC721Metadata} from "@solidstate/contracts/token/ERC721/metadata/ERC721Metadata.sol";

// extract Type to a separate file
import {TokenURIParams} from "./Types.sol";

// extract NFT generation to a library to save on gas
import {NFTGenerator} from "./libraries/NFTGenerator.sol";

/**
 * 1. Figure out the most optimized way of storing 5k genomes on chain, while reducing gas costs
 * 2. Implement a function to decode a genome, and return genome attributes
 * 3. Describe your thought process along the way of solving this problem
 */

contract GenomeNFT is ERC721Metadata {
  // keep last token ID internally
  // intialize with 0 to save gas on first write
  uint256 private _tokenId = 0;

  // keeping genome NFTs on chain
  mapping(uint256 => bytes) private genomeNfts;

  // I experimented this approach with fixed array,
  // but gas in total was more than using mapping
  // in EVM mappings are (mostly) cheaper than arrays
  // bytes[500] private genomeNfts;

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
  ) public {
    // we can use unchecked asuming that there will be only 5k NFTs
    // and no overflow would happen
    unchecked {
      // increment token id inline to save on gas
      genomeNfts[++_tokenId] = NFTGenerator.generate( // convert nft data to bytes
        nftName,
        description,
        attributes
      );
    }

    // mint the NFT with token ID that was incremented
    _mint(_address, _tokenId);
  }

  function tokenURI(uint256 id) public view override returns (string memory) {
    return string(genomeNfts[id]);
  }
}
