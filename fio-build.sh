#!/bin/sh -ex

make -C components/engine VERSION="19.03.5-cowboy-$(git log -1 --format=%h)" DOCKER_CROSSPLATFORMS=linux/arm cross
make -C components/cli VERSION="19.03.5-cowboy-$(git log -1 --format=%h)" DOCKER_CROSSPLATFORMS=linux/arm -f docker.Makefile cross

mkdir docker-dind-arm
cp components/cli/build/docker-linux-arm docker-dind-arm/
cp components/engine/bundles/cross/linux/arm/dockerd docker-dind-arm/
cat > docker-dind-arm/Dockerfile <<EOF
FROM docker:dind

ENV GOARCH_VARIANT=v7
COPY dockerd /usr/local/bin/dockerd
COPY docker-linux-arm /usr/local/bin/docker
EOF

tar czf docker-dind-arm.tgz docker-dind-arm
