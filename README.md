## Deployed Contracts

LuaNameRegistry:
https://goerli.etherscan.io/address/0xd78fdaf7aa9d73dbd8b3b96cc842315f6e63e053
https://gnosisscan.io/address/0x487b88949305bd891337e34ed35060dac42b8535

LuaUserValues:
https://goerli.etherscan.io/address/0xde4Ecc89d8D5Cb11AaAfa67FC1c3972503aB0021
https://gnosisscan.io/address/0x1EB4beEc0DB7fc25b84b62c36b0483eb40e65557

LuaRequestPayment:
https://goerli.etherscan.io/address/0x9B3DB51c73E27C25bd19bE7af3e4D128C8ad9b36
https://gnosisscan.io/address/0x77AE090463E47AFe9e33182a8C020fAD239Dd788

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
