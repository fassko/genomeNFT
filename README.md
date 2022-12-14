# Genome NFT

## Tasks

1. Figure out the most optimized way of storing 5k genomes on the chain while reducing gas costs
2. Implement a function to decode a genome, and return genome attributes
3. Describe your thought process along the way of solving this problem

## Solution

I decided to save NFT data into a mapping where the key is `uint256` representing the token ID, and the value is `bytes` that stores NFT JSON data according to the ERC721 metadata standard.

NFT image is stored on the chain using SVG base64 encoded because any modern browser can read and display.

To retrieve the NFT data, we get the bytes from the mapping, convert them to a string, and return it.

Option B is to use `memory`, not the `calldata`, passing the parameters struct `TokenURIParams`. That can save on minting but more on deployment.

## Running the project

### Install dependencies

```shell
npm install
```

### Run tests with the gas report

```shell
REPORT_GAS=true npx hardhat test
```
