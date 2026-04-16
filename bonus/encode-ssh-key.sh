#!/usr/bin/env bash

# To be used for mirroring job
base64 $1 | tr -d '\n' ; echo
