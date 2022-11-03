// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

// use base64 encode library
import {Base64} from "base64-sol/base64.sol";

// import Uint utils to convert int to string
import {UintUtils} from "@solidstate/contracts/utils/UintUtils.sol";

// export SVG creation to a library
import {NFTSVG} from "./NFTSVG.sol";

// common type exported to a separate file
import {TokenURIParams} from "../Types.sol";

library NFTGenerator {
  // to convert uint to string
  using UintUtils for uint8;

  // generate NFT data according to the ERC721 Metadata JSON Schema
  function generate(
    string memory name,
    string memory description,
    TokenURIParams calldata _attributes
  ) internal pure returns (bytes memory) {
    return
      bytes(
        string(
          abi.encodePacked(
            "data:application/json;base64,",
            bytes(
              abi.encodePacked(
                "{",
                '"image":"',
                "data:image/svg+xml;base64,",
                // Base64 encode image so any morend browser can read it
                Base64.encode(bytes(NFTSVG.buildSVGImage())),
                '",',
                '"description":"',
                description,
                '",',
                '"name":"',
                name,
                '",',
                generateAttributes(_attributes),
                "}"
              )
            )
          )
        )
      );
  }

  // generate attributes array
  function generateAttributes(TokenURIParams calldata attributes)
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
          "},",
          '{"traitType": "BackgroundEffect","value":',
          attributes.backgroundEffect.toString(),
          "},",
          '{"traitType": "Wings","value":',
          attributes.wings.toString(),
          "},",
          '{"traitType": "SkinColor", "value":',
          attributes.skinColor.toString(),
          "},",
          '{"traitType": "SkinPattern","value":',
          attributes.skinColor.toString(),
          "},",
          '{"traitType": "Body","value":',
          attributes.body.toString(),
          "},",
          '{"traitType": "Mouth","value":',
          attributes.mouth.toString(),
          "},",
          '{"traitType": "Eyes", "value":',
          attributes.eyes.toString(),
          "},",
          '{"traitType": "Hat", "value":',
          attributes.hat.toString(),
          "},",
          '{"traitType": "Pet", "value":',
          attributes.pet.toString(),
          "},",
          '{"traitType": "Accessory", "value":',
          attributes.accessory.toString(),
          "},",
          '{"traitType": "Border", "value":',
          attributes.border.toString(),
          "}]"
        )
      );
  }
}
