// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.17;

library NFTSVG {
  // won't implement SVG image creation, just a wrapper
  // image will be a base64 encoded SVG image stored on chain
  function buildSVGImage() internal pure returns (string memory) {
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
