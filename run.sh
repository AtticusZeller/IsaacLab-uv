#!/usr/bin/env bash

# Shared Configuration
TASKS=(
    "Isaac-Velocity-Rough-G1-v0"
    "Isaac-Velocity-Rough-H1-v0"
    "Isaac-Velocity-Rough-Anymal-D-v0"
    "Isaac-Velocity-Rough-Unitree-Go2-v0"
)

# Load environment variables if .env exists (used for sync)
if [ -f .env ]; then
    set -a
    source .env
    set +a
fi

# Help Function
show_help() {
    echo "Usage: $0 [command] [options]"
    echo ""
    echo "Commands:"
    echo "  train    Start training a policy"
    echo "  play     Run inference/playback of a policy"
    echo "  sync     Sync logs from remote server"
    echo ""
    echo "Examples:"
    echo "  $0 train --task Isaac-Velocity-Rough-H1-v0"
    echo "  $0 play --task Isaac-Velocity-Rough-H1-v0 --webrtc"
    echo "  $0 sync"
    echo ""
}

# ---------------------------------------------------------
# COMMAND: TRAIN
# ---------------------------------------------------------
cmd_train() {
    local TASK=""
    local RUN_NAME=""
    
    # Parse arguments specific to training
    while [[ $# -gt 0 ]]; do
        case $1 in
            --task)
                TASK="$2"
                shift 2
                ;;
            --run_name)
                RUN_NAME="$2"
                shift 2
                ;;
            *)
                echo "Unknown parameter for train: $1"
                exit 1
                ;;
        esac
    done

    if [ -z "$TASK" ]; then
        echo "Error: Please specify --task"
        echo "Available tasks:"
        printf '  • %s\n' "${TASKS[@]}"
        exit 1
    fi

    if [ -z "$RUN_NAME" ]; then
        # Extract the part after Isaac-, remove -v0
        RUN_NAME=$(echo "$TASK" | sed 's/Isaac-//;s/-v[0-9]$//')
    fi

    echo "Starting training..."
    echo "Task: $TASK"
    echo "Run Name: $RUN_NAME"

    python isaaclab/scripts/reinforcement_learning/rsl_rl/train.py \
        --task="$TASK" \
        --device cuda:1 \
        --headless \
        --logger wandb \
        --run_name "$RUN_NAME" \
        --log_project_name isaaclab
}

# ---------------------------------------------------------
# COMMAND: PLAY
# ---------------------------------------------------------
cmd_play() {
    local TASK=""
    local NUM_ENVS=128
    local RESUME=""
    local LOAD_RUN=""
    local CHECKPOINT=""
    local USE_WEBRTC=false

    # Parse arguments specific to play
    while [[ $# -gt 0 ]]; do
        case $1 in
            --task)       TASK="$2"; shift 2 ;;
            --num_envs)   NUM_ENVS="$2"; shift 2 ;;
            --resume)     RESUME="--resume"; shift ;;
            --load_run)   LOAD_RUN="--load_run $2"; shift 2 ;;
            --checkpoint) CHECKPOINT="--checkpoint $2"; shift 2 ;;
            --webrtc)     USE_WEBRTC=true; shift ;;
            *)            echo "Unknown parameter for play: $1"; exit 1 ;;
        esac
    done

    if [ -z "$TASK" ]; then
        echo "Error: Please specify --task"
        echo "Available tasks:"
        printf '  • %s\n' "${TASKS[@]}"
        exit 1
    fi

    local LIVESTREAM_PARAM=""
    local DISPLAY_MODE="GUI"
    if [ "$USE_WEBRTC" = true ]; then
        LIVESTREAM_PARAM="--livestream 2"
        DISPLAY_MODE="WebRTC"
    fi

    echo "Starting inference..."
    echo "Task: $TASK"
    echo "Num Envs: $NUM_ENVS"
    echo "Display: $DISPLAY_MODE"

    python isaaclab/scripts/reinforcement_learning/rsl_rl/play.py \
        --task="$TASK" \
        --num_envs $NUM_ENVS \
        $LIVESTREAM_PARAM \
        --rendering_mode balanced \
        --device cuda:1 \
        $RESUME \
        $LOAD_RUN \
        $CHECKPOINT
}

# ---------------------------------------------------------
# COMMAND: SYNC
# ---------------------------------------------------------
cmd_sync() {
    # Configuration paths
    local REMOTE_PATH="/root/DevSpace/IsaacLab-uv/logs/"
    local LOCAL_PATH="$HOME/DevSpace/IsaacLab-uv/logs/"

    echo "Starting sync from AutoDL..."
    
    if ! command -v sshpass &> /dev/null; then
        echo "Error: sshpass is not installed."
        exit 1
    fi

    # Ensure env vars are set
    if [ -z "$HOST" ] || [ -z "$PORT" ] || [ -z "$PASSWORD" ]; then
        echo "Error: HOST, PORT, or PASSWORD not set in .env"
        exit 1
    fi

    sshpass -p "$PASSWORD" rsync -avzP \
        -e "ssh -p $PORT -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null" \
        --exclude '*.tfevents*' \
        "root@$HOST:$REMOTE_PATH" "$LOCAL_PATH"
        
    echo "Sync finished."
}

# ---------------------------------------------------------
# MAIN DISPATCHER
# ---------------------------------------------------------
COMMAND="$1"
shift # Remove the command name from args, leaving the flags

case "$COMMAND" in
    train)
        cmd_train "$@"
        ;;
    play)
        cmd_play "$@"
        ;;
    sync)
        cmd_sync
        ;;
    *)
        show_help
        exit 1
        ;;
esac