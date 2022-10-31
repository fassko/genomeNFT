// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

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
  using UintUtils for uint256;

  uint256 private tokenId;
  mapping(uint256 => bytes) private genomeNfts;

  event GenomeNFTMinted(uint256 id);

  struct TokenURIParams {
    uint256 backgroundColor;
    uint256 backgroundEffect;
    uint256 wings;
    uint256 skinColor;
    uint256 skinPattern;
    uint256 body;
    uint256 mouth;
    uint256 eyes;
    uint256 hat;
    uint256 pet;
    uint256 accessory;
    uint256 border;
  }

  constructor(
    string memory name,
    string memory symbol,
    string memory baseURI
  ) {
    ERC721MetadataStorage.Layout storage l = ERC721MetadataStorage.layout();
    l.name = name;
    l.symbol = symbol;
    l.baseURI = baseURI;
  }

  function mint(
    address _address,
    string memory name,
    string memory description,
    TokenURIParams memory attributes
  ) external returns (uint256) {
    tokenId = tokenId + 1;

    genomeNfts[tokenId] = bytes(generateNFTData(name, description, attributes));
    _mint(_address, tokenId);

    emit GenomeNFTMinted(tokenId);

    return tokenId;
  }

  function getTokenURI(uint256 id) public view returns (string memory) {
    return string(genomeNfts[id]);
  }

  function tokenURI(uint256 id) external view override returns (string memory) {
    return getTokenURI(id);
  }

  function generateNFTData(
    string memory name,
    string memory description,
    TokenURIParams memory _attributes
  ) private pure returns (string memory) {
    string memory base64image;
    {
      string memory svgImage = buildSVGImage();
      base64image = Base64.encode(bytes(svgImage));
    }
    string memory attributes = generateAttributes(_attributes);

    return
      string(
        abi.encodePacked(
          "data:application/json;base64,",
          Base64.encode(
            bytes(
              abi.encodePacked(
                "{",
                '"image":"',
                "data:image/svg+xml;base64,",
                base64image,
                '",',
                '"description":"',
                description,
                '",',
                '"name":"',
                name,
                '",',
                attributes,
                "}"
              )
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

  function buildSVGImage() private pure returns (string memory) {
    // won't implement SVG image creation, just a wrapper

    return
      string(
        abi.encodePacked(
          '<svg width="300" height="378" viewBox="0 0 300 378" fill="none" xmlns="http://www.w3.org/2000/svg">',
          "</svg>"
        )
      );
  }
}
