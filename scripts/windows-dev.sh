#!/bin/sh
# Typically I use git bash to run this:

set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

rojo serve build.project.json \
    & rojo sourcemap default.project.json -o sourcemap.json --watch \
	& wally-package-types --sourcemap sourcemap.json Packages/ \
    & ROBLOX_DEV=true darklua process --config .darklua.json --watch src/Client dist/Client \
	& ROBLOX_DEV=true darklua process --config .darklua.json --watch src/Common dist/Common \
	& ROBLOX_DEV=true darklua process --config .darklua.json --watch src/Server dist/Server \