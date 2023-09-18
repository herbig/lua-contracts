#!/bin/bash
source .env
forge create --rpc-url https://rpc.ankr.com/eth_goerli --private-key $PRIVATE_KEY  src/LuaNameRegistry.sol:LuaNameRegistry --etherscan-api-key $API_KEY_ETHERSCAN --verify
forge create --rpc-url https://rpc.ankr.com/eth_goerli --private-key $PRIVATE_KEY  src/LuaUserValues.sol:LuaUserValues --etherscan-api-key $API_KEY_ETHERSCAN --verify
forge create --rpc-url https://rpc.ankr.com/eth_goerli --private-key $PRIVATE_KEY  src/LuaRequestPayment.sol:LuaRequestPayment --etherscan-api-key $API_KEY_ETHERSCAN --verify