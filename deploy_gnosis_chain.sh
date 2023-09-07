#!/bin/bash
source .env
forge create --rpc-url https://rpc.gnosis.gateway.fm --chain 100 --private-key $PRIVATE_KEY --etherscan-api-key $API_KEY_GNOSISSCAN --verify --verifier blockscout --verifier-url https://api.gnosisscan.io/api src/LuaNameRegistry.sol:LuaNameRegistry