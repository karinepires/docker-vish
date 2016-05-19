# docker-vish

Unofficial Dockerfile for ViSH open source e-Learning platform http://vishub.org

!!!!! DO NOT USE THIS IN PRODUCTION !!!!!

For testing purposes only.

You can either build it yourself:

```bash
# Clone this repository
git clone https://github.com/karinepires/docker-vish

# Build docker image
cd docker-vish
docker build -t docker-vish  ./

# Start container
docker run -d -P docker-vish
```

Or pull it from [docker hub](https://hub.docker.com/r/karine/vish/):

```bash
# Download docker image
docker pull karine/vish

# Start container
docker run -d -P karine/vish
```
