import { ethers } from "hardhat";

async function main() {
  const socialM = await ethers.deployContract("SocialMedia");

  await socialM.waitForDeployment();

  console.log(`SocialMedia deployed to ${socialM.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
