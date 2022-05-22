const ethers = hre.ethers;

async function main() {
	const [me] = await ethers.getSigners();
    console.log('[+] My address: ', me.address);

    const Launcher = await ethers.getContractFactory("Launcher");
    const launcher = await Launcher.deploy();

    await launcher.main();
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });