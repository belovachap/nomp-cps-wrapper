#!/bin/bash

response=$(curl -Ss -u 'rpc:rpc' -d '{"jsonrpc": "1.0", "id": "curltest", "method": "getblockcount", "params": []}' -H 'content-type: text/plain;' http://localhost:9902/)
error=$(echo "$response" | jq -r '.error')

if [ "$error" == "null" ]; then
    count=$(echo "$response" | jq -r '.result')
    if [ "$count" -lt "$1" ]; then
        exit 1
    fi
else
    exit 1
fi
