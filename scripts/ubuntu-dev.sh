#!/bin/bash
# The windows-dev.sh script typically doesn't work for on linux me because of the watchers.
# This is a script that works on Ubuntu (and maybe other Linux distros):
set -e

# If Packages aren't installed, install them.
if [ ! -d "Packages" ]; then
    sh scripts/install-packages.sh
fi

rojo serve build.project.json & \
# rojo sourcemap default.project.json -o sourcemap.json --watch &
wally-package-types --sourcemap sourcemap.json Packages/ &
# ROBLOX_DEV=true darklua process --config .darklua.json --watch src/Client dist/Client &
# ROBLOX_DEV=true darklua process --config .darklua.json --watch src/Common dist/Common &
# ROBLOX_DEV=true darklua process --config .darklua.json --watch src/Server dist/Server

DARKLUAC_CLIENT_SRC="src/Client"
DARKLUAC_COMMON_SRC="src/Common"
DARKLUAC_SERVER_SRC="src/Server"

# Function to run darklua process for a given source and dest
run_darklua() {
    local src_dir="$1"
    local dest_dir="$2"
    echo "Running darklua for $src_dir..."
    ROBLOX_DEV=true darklua process --config .darklua.json "$src_dir" "$dest_dir"
    echo "Finished darklua for $src_dir."
}

# Initial run of darklua for all modules
run_darklua "$DARKLUAC_CLIENT_SRC" "dist/Client"
run_darklua "$DARKLUAC_COMMON_SRC" "dist/Common"
run_darklua "$DARKLUAC_SERVER_SRC" "dist/Server"

# Start the inotifywait loop in the background
(
    echo "Watching for file changes in Darklua source directories..."
    # Loop indefinitely, waiting for changes in any of the specified directories.
    # -r: recursive
    # -e modify,create,delete,move: events to watch for
    # --format '%w%f': output format (directory + filename)
    inotifywait -m -r -e modify,create,delete,move \
        "$DARKLUAC_CLIENT_SRC" \
        "$DARKLUAC_COMMON_SRC" \
        "$DARKLUAC_SERVER_SRC" \
    | while read path action file; do
        # Determine which darklua command to run based on the changed path
        case "$path" in
            "$DARKLUAC_CLIENT_SRC"*)
                run_darklua "$DARKLUAC_CLIENT_SRC" "dist/Client"
                ;;
            "$DARKLUAC_COMMON_SRC"*)
                run_darklua "$DARKLUAC_COMMON_SRC" "dist/Common"
                ;;
            "$DARKLUAC_SERVER_SRC"*)
                run_darklua "$DARKLUAC_SERVER_SRC" "dist/Server"
                ;;
            *)
                echo "Unknown path changed: $path"
                ;;
        esac
    done
) &

wait