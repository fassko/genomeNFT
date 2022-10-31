import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat";
import { GenomeNFT } from "../typechain-types";

describe("GenomeNFT", function () {

  async function deployFixture() {
    const [owner, otherAccount] = await ethers.getSigners();

    const GenomeNFT = await ethers.getContractFactory("GenomeNFT");
    const genomeNFT = await GenomeNFT.deploy("Genome", "GNM", "http://genome.example/");

    return { genomeNFT, owner, otherAccount };
  }

  describe("Deployment", function () {
    it("Should set the right unlockTime", async function () {
      const { genomeNFT, otherAccount } = await loadFixture(deployFixture);

      const params: GenomeNFT.TokenURIParamsStruct = {
        backgroundColor: 60,
        backgroundEffect: 30,
        wings: 10,
        skinColor: 40,
        skinPattern: 40,
        body: 10,
        mouth: 50,
        eyes: 60,
        hat: 100,
        pet: 10,
        accessory: 25,
        border: 30
      };

      const tnx = await genomeNFT.mint(otherAccount.address, "Genome", "Test Genome", params);

      const txResult = await tnx.wait();
      const event = txResult?.events?.find(event => event.event == "GenomeNFTMinted");
      const tokenId = event?.args![0];

      console.log(tokenId);

      const tokenURI = await genomeNFT.getTokenURI(1);

      console.log(tokenURI);
    });
  });
});
