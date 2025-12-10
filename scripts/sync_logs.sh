#!/usr/bin/env bash

# ================= CONFIGURATION =================
# Update these lines when your AutoDL instance changes
HOST="connect.bjb2.seetacloud.com"
PORT="29549"
PASSWORD="IrdJwEymMHqt"

# Paths (Keep trailing slashes)
REMOTE_PATH="/root/Devspace/IsaacLab-uv/isaaclab/logs/"
LOCAL_PATH="$HOME/DevSpace/IsaacLab-uv/isaaclab/logs/"
# =================================================

echo "Starting sync from AutoDL..."

# Check if sshpass is installed
if ! command -v sshpass &> /dev/null; then
    echo "Error: sshpass is not installed. Please install it first."
    exit 1
fi

# Run rsync
# Explanation of flags:
# -avzP: archive, verbose, compress, progress/partial
# -e: specifies the ssh command
# -o StrictHostKeyChecking=no: prevents 'Are you sure...' prompt
# -o UserKnownHostsFile=/dev/null: ignores known_hosts file (avoids errors when port matches old instance)
# --exclude: skips tensorboard files to save time

sshpass -p "$PASSWORD" rsync -avzP \
    -e "ssh -p $PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
    --exclude '*.tfevents*' \
    "root@$HOST:$REMOTE_PATH" "$LOCAL_PATH"

echo "Sync finished."