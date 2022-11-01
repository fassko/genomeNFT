// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {ERC721Metadata} from "@solidstate/contracts/token/ERC721/metadata/ERC721Metadata.sol";
import {ERC721MetadataStorage} from "@solidstate/contracts/token/ERC721/metadata/ERC721MetadataStorage.sol";
import {Base64} from "base64-sol/base64.sol";
import {UintUtils} from "@solidstate/contracts/utils/UintUtils.sol";

/**
 * 1. Figure out the most optimized way of storing 5k genomes on chain, while reducing gas costs
 * 2. Implement a function to decode a genome, and return genome attributes
 * 3. Describe your thought process along the way of solving this problem
 */

contract GenomeNFT is ERC721Metadata {
  // to convert int to string
  using UintUtils for uint8;

  // keep token ID
  uint16 private tokenId;

  // keeping genome NFTs on chain
  // 5000 nfts so can use uint16
  mapping(uint16 => bytes) private genomeNfts;

  event GenomeNFTMinted(uint256 id);

  struct TokenURIParams {
    uint8 backgroundColor;
    uint8 backgroundEffect;
    uint8 wings;
    uint8 skinColor;
    uint8 skinPattern;
    uint8 body;
    uint8 mouth;
    uint8 eyes;
    uint8 hat;
    uint8 pet;
    uint8 accessory;
    uint8 border;
  }

  constructor(
    string memory tokenName,
    string memory tokenSymbol,
    string memory baseURI
  ) {
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

    genomeNfts[tokenId] = bytes(
      generateNFTData(nftName, description, attributes)
    );
    _mint(_address, tokenId);

    emit GenomeNFTMinted(tokenId);

    return tokenId;
  }

  function tokenURI(uint256 id) external view override returns (string memory) {
    return string(genomeNfts[uint16(id)]);
  }

  function generateNFTData(
    string memory nftName,
    string memory description,
    TokenURIParams memory _attributes
  ) private pure returns (string memory) {
    return
      string(
        abi.encodePacked(
          "data:application/json;base64,",
          bytes(
            abi.encodePacked(
              "{",
              '"image":"',
              "data:image/svg+xml;base64,",
              // Base64 encode image so a browser can read it
              Base64.encode(bytes(buildSVGImage())),
              '",',
              '"description":"',
              description,
              '",',
              '"name":"',
              nftName,
              '",',
              generateAttributes(_attributes),
              "}"
            )
          )
        )
      );
  }

  function generateAttributes(TokenURIParams memory attributes)
    private
    pure
    returns (string memory)
  {
    return
      string(
        abi.encodePacked(
          '"attributes":[',
          '{"traitType": "BackgroundColor","value":',
          attributes.backgroundColor.toString(),
          '"},',
          '{"traitType": "BackgroundEffect","value":',
          attributes.backgroundEffect.toString(),
          '"},',
          '{"traitType": "Wings","value":',
          attributes.wings.toString(),
          '"},',
          '{"traitType": "SkinColor", "value":',
          attributes.skinColor.toString(),
          '"},',
          '{"traitType": "SkinPattern","value":',
          attributes.skinColor.toString(),
          '"},',
          '{"traitType": "Body","value":',
          attributes.body.toString(),
          '"},',
          '{"traitType": "Mouth","value":',
          attributes.mouth.toString(),
          '"},',
          '{"traitType": "Eyes", "value":',
          attributes.eyes.toString(),
          '"},',
          '{"traitType": "Hat", "value":',
          attributes.hat.toString(),
          '"},',
          '{"traitType": "Pet", "value":',
          attributes.pet.toString(),
          '"},',
          '{"traitType": "Accessory", "value":',
          attributes.accessory.toString(),
          '"},',
          '{"traitType": "Border", "value":',
          attributes.border.toString(),
          '"}]'
        )
      );
  }

  // won't implement SVG image creation, just a wrapper
  // image will be a base64 encoded SVG image stored on chain
  function buildSVGImage() private pure returns (string memory) {
    return
      string(
        abi.encodePacked(
          '<svg width="300" height="378" viewBox="0 0 300 378" fill="none" xmlns="http://www.w3.org/2000/svg">',
          // need to generate here rest of the image
          // that is out of scope of this test task
          "</svg>"
        )
      );
  }
}
