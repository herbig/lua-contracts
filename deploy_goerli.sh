#!/bin/bash
source .env
forge create --rpc-url https://rpc.ankr.com/eth_goerli --private-key $PRIVATE_KEY  src/LuaNameRegistry.sol:LuaNameRegistry --etherscan-api-key $API_KEY_ETHERSCAN --verify