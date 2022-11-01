// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

import {Base64} from "base64-sol/base64.sol";
import {UintUtils} from "@solidstate/contracts/utils/UintUtils.sol";

import {NFTSVG} from "./NFTSVG.sol";
import {TokenURIParams} from "../Types.sol";

library NFTGenerator {
  // to convert int to string
  using UintUtils for uint8;

  function generate(
    string memory nftName,
    string memory description,
    TokenURIParams memory _attributes
  ) internal pure returns (string memory) {
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
              Base64.encode(bytes(NFTSVG.buildSVGImage())),
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
