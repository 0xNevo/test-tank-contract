import { ethers } from "hardhat";

async function main() {
  const nft_name = "Super_Tank_Collection";
  const nft_symbol = "STC";

  const TankMint = await ethers.getContractFactory("TankMint");
  const tankMint = await TankMint.deploy(nft_name, nft_symbol);

  await tankMint.deployed();

  console.log(`Tank Contract is deployed to: ${tankMint.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
