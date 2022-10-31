import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
import "hardhat-watcher";
import "hardhat-gas-reporter";
import Dotenv from 'dotenv';
Dotenv.config();

const config: HardhatUserConfig = {
  solidity: "0.8.17",
  watcher: {
    contracts: {
      tasks: ['compile'],
      files: ['./contracts'],
      verbose: true,
    }
  },
  gasReporter: {
    enabled: (process.env.REPORT_GAS) ? true : false
  }
};

export default config;
