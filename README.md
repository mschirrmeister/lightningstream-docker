# PowerDNS - Lightning Stream - Docker

This project provides a **Dockerfile** for [**Lightning Stream**](https://github.com/PowerDNS/lightningstream/) project.

Images are available on Dockerhub for `arm64` and `amd64`.

## Examples

Default

    docker run -it -d \
      --name lightningstream \
      -p 8500:8500/tcp \
      -v ./lightningstream.yaml:/app/lightningstream.yaml:ro \
      -e PUID=953 \
      -e PORT=8500 \
      mschirrmeister/lightningstream:latest

If you want to modify some start parameters, specify everything how you want to run it

    docker run -it -d \
      --name lightningstream \
      -p 8500:8500/tcp \
      -v ./lightningstream.yaml:/app/lightningstream.yaml:ro \
      -e PUID=953 \
      -e PORT=8500 \
      mschirrmeister/lightningstream:latest /app/lightningstream --config /app/lightningstream.yaml --minimum-pid 50 --debug receive

If you need some more logic before starting the daemon, mount a script into the container and specify everything in the script. See notes below.

    docker run -it -d \
      --name lightningstream \
      -p 8500:8500/tcp \
      -v ./lightningstream.yaml:/app/lightningstream.yaml:ro \
      -v ./start.sh:/app/start.sh \
      -e PUID=953 \
      -e PORT=8500 \
      -e PDNS_LSTREAM_SLEEP=xxx \
      -e PDNS_LSTREAM_DNS_SERVER=xxx \
      -e PDNS_LSTREAM_DOMAIN=xxx \
      mschirrmeister/lightningstream:latest start.sh
