# How to run

I'm using docker, installed via https://docs.docker.com/engine/install/ubuntu/

In general and on any config changes:
```
docker compose up -d --build
# optional, to check logs
docker compose logs -f
```

By default the pool is exposed on port 3448 (see [docker-compose.yml](/docker-compose.yml)).

There are a couple of configurations that need to be considered.
We need a target address to mine to, and for that a wallet.dat needs to be present when peercoind is run.

### Create wallet and target address

<b>Alternatively one may also choose to pre-generate a new wallet on the desktop client, note down the new address and then place it in the mounted volume mentioned below.</b>

```
docker compose up -d peercoind
docker compose exec --user=peercoin peercoind peercoin-cli -datadir=/data -rpcuser=rpc -rpcpassword=rpc createwallet test false false '' false false
docker compose exec --user=peercoin peercoind peercoin-cli -datadir=/data -rpcuser=rpc -rpcpassword=rpc -rpcwallet=test getnewaddress
````

This will create<br>
a) a wallet file inside the mounted docker volume (eg. `/var/lib/docker/volumes/nomp-cps-wrapper_peercoind-data/_data/test/wallet.dat`), so make sure to back this up somewhere safe<br>
b) a new address to use for the pool config

### Update pool config

In [pool/app/pool_configs/peercoin.json](/pool/app/pool_configs/peercoin.json) the "address" field can be updated using your newly generated address.

### Configure cgminer

Currently cgminer is built using `CFLAGS="-O2 -march=native -fcommon" ./autogen.sh --enable-gekko --without-curses`.<br>
[/cgminer/Dockerfile](/cgminer/Dockerfile) can be updated with your hardware specific flags (see also https://github.com/kanoi/cgminer).

### peercoind healthcheck

[docker-compose.yml](/docker-compose.yml) -> peercoind: contains a healthcheck section. Here is an alternative configuration for it:

The first arg check for blockcount, so  this useful on startup, so that other services do not interfere while peercoin is syncing
```
    healthcheck:
      test: ["CMD", "healthcheck.sh", "730000"]
      retries: 9999999999
```

General healthcheck to verify the service is booting and has connectivity at all
```
    healthcheck:
      test: ["CMD", "healthcheck.sh", "1"]
      interval: 10s
      timeout: 5s
      retries: 3
```
