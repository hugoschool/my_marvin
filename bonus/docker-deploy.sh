#!/usr/bin/env bash

set -e

if [ ! -f Dockerfile ]; then
    echo "No docker file found in repo, exiting."
    exit 1
fi

IMAGE_NAME=$1
IMAGE_TAG="latest"
SSH_HOST=$2
DOCKER_OPTIONS=$3
SSH_KEY=$4

docker build -t $IMAGE_NAME:$IMAGE_TAG .

docker image save $IMAGE_NAME:$IMAGE_TAG -o $IMAGE_NAME.tar

mkdir -p ~/.ssh
echo "$SSH_KEY" | base64 -d > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Generate the known_hosts with `./get-known_hosts.sh <IP_ADDRESS>`
echo "165.22.124.154 ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRiW5PFuOVjcV1S2PcpohK+fETFjJo8b2CpUvy5oI4s
165.22.124.154 ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDmxmbG/GsgiTkMRccodxvgYErM5DsW3kH6MMalzSfos9t72rV9K1Bq00HPpM3EHKK1EZmwEDzFMKYDnzX9kxCsEXz61JYFYTw0X98h9CUPszIPKMxn5Wx4Lwse65pLbeM7EcanN0+nWYoUjA5WHF5K/Fc4x6pNg9tQUDThOQmbh3ydqR6HBNqqB2/AhmGpbW/pVwp7HgCOxpKUVxqN2xvXRFlCs+R1jkzfiYJIMc040eSVTaTcLmv7eWbgcn9me8Eu1IxY6CcnFLIfltjzOVsa7YnrfbdRKQbPMMvJdYF2keUhDITWR/2CP6qgORxLf5ehZ09EA0ijhg5VObDhmbKLQJDyyQBpeD7aYQAJ7+lYXcFr5eF18qjU45VlMM5o5Lp7skQpu/iGTcRn398/p/3fVA/scaNVaQkd2WeXoGGzNSjsoaldW+Lta2ryraH9RjvpBAHw6AXGEtaMztdYrDUq5dlY2OCFCt116viOx7PKih7aU+5CHLbTTzF04P34Xgs=
165.22.124.154 ecdsa-sha2-nistp256 AAAAE2VjZHNhLXNoYTItbmlzdHAyNTYAAAAIbmlzdHAyNTYAAABBBG2KU2fKoXfd1WDi6NHqrM0ItMm8FoDjKjSyXiyGLGuYoFfQsoBoiYvV0ZjxJX5TqalEpomABZ0ja/MWiax9+Hw=" > ~/.ssh/known_hosts

scp $IMAGE_NAME.tar $SSH_HOST:/tmp/$IMAGE_NAME.tar
ssh $SSH_HOST docker image load -i /tmp/$IMAGE_NAME.tar
ssh $SSH_HOST docker run $DOCKER_OPTIONS $IMAGE_NAME:$IMAGE_TAG
