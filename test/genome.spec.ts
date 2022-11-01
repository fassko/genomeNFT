import { loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { ethers } from "hardhat";

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

      const params = {
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
      const result = await tnx.wait();

      const tokenId = result.events?.[0].args?.[2]
      const tokenURI = await genomeNFT.tokenURI(tokenId);

      console.log(tokenURI);
    });
  });
});
