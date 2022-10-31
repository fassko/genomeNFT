import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-watcher";

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  watcher: {
    contracts: {
        tasks: ['compile'],
        files: ['./contracts'],
        verbose: true,
    }
},
};

export default config;
