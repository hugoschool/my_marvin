#!/usr/bin/env bash
# Inspired by https://github.com/pixta-dev/repository-mirroring-action

set -eu

if [ -z $1 ] || [ -z $2 ]; then
    echo "Missing parameter, exiting without mirror"
    exit 0
fi

mkdir -p ~/.ssh
echo "$1" | base64 -d > ~/.ssh/id_rsa
chmod 600 ~/.ssh/id_rsa

# Add lost of known hosts as to not bother with it
curl https://knownhosts.net > ~/.ssh/known_hosts

git remote remove mirror || true
git remote add mirror $2
git config core.sshCommand "ssh -i ~/.ssh/id_rsa"
git push --force --prune mirror "refs/remotes/origin/*:refs/heads/*"
git remote remove mirror

rm ~/.ssh/id_rsa
