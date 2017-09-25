# Caddy build from source with plugins on RPI

This Dockerfile builds the caddy server from a specific tag from github and adds
the plugins created by `configre.sh`. It's based on ulrichSchreiner's [caddy-builder](https://github.com/ulrichSchreiner/caddy-builder) for the compile step and ulrichSchreiner's [caddy-runtime](https://github.com/ulrichSchreiner/caddy-runtime) as the runtime image. Runtime image utilizes `s6-setuidgid` to drop privileges
***Caddy will run with UID 82 (www-data) and not as root!***

## Build Instructions
```
git clone https://github.com/whw3/caddy-http.git
cd caddy-http
./configure.sh
make
```
## Runtime 
1. start
...  `make start`
2. stop
... `make stop`


###Requirements
* jq
* docker-compose

No worrys `configure.sh` will install them if missing

#TODO
1. actually write content for docker-compose.yml
* include php options
* 