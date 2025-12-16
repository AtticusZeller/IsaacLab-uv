#!/usr/bin/env bash

# Available task list
TASKS=(
"Isaac-Velocity-Rough-G1-v0"
"Isaac-Velocity-Rough-H1-v0"
"Isaac-Velocity-Rough-Anymal-D-v0"
"Isaac-Velocity-Rough-Unitree-Go2-v0"
)

# Default values
TASK=""
NUM_ENVS=128
RESUME=""
LOAD_RUN=""
CHECKPOINT=""
USE_WEBRTC=false

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --task)
            TASK="$2"
            shift 2
            ;;
        --num_envs)
            NUM_ENVS="$2"
            shift 2
            ;;
        --resume)
            RESUME="--resume"
            shift
            ;;
        --load_run)
            LOAD_RUN="--load_run $2"
            shift 2
            ;;
        --checkpoint)
            CHECKPOINT="--checkpoint $2"
            shift 2
            ;;
        --webrtc)
            USE_WEBRTC=true
            shift
            ;;
        *)
            echo "❌ Unknown argument: $1"
            exit 1
            ;;
    esac
done

# Check if task is provided
if [ -z "$TASK" ]; then
    echo "❌ Please specify --task"
    echo ""
    echo "📋 Available tasks:"
    printf '   • %s\n' "${TASKS[@]}"
    echo ""
    echo "💡 Usage: $0 --task Isaac-Velocity-Rough-H1-v0 [options]"
    echo ""
    echo "📝 Optional arguments:"
    echo "   --num_envs N      Number of environments (default: 128)"
    echo "   --resume          Resume from a checkpoint"
    echo "   --load_run NAME   Load a specific run"
    echo "   --checkpoint FILE Specify a checkpoint file"
    echo "   --webrtc          Enable WebRTC streaming (default: GUI)"
    exit 1
fi

# Set livestream parameter based on webrtc flag
if [ "$USE_WEBRTC" = true ]; then
    LIVESTREAM_PARAM="--livestream 2"
    DISPLAY_MODE="WebRTC"
else
    LIVESTREAM_PARAM=""
    DISPLAY_MODE="GUI"
fi

echo "🎮 Starting inference"
echo "📦 Task: $TASK"
echo "🔢 Num Envs: $NUM_ENVS"
echo "🖥️  Display: $DISPLAY_MODE"
[ -n "$RESUME" ] && echo "♻️  Resume: Yes"
[ -n "$LOAD_RUN" ] && echo "📂 Load Run: ${LOAD_RUN#--load_run }"
[ -n "$CHECKPOINT" ] && echo "💾 Checkpoint: ${CHECKPOINT#--checkpoint }"
echo ""

# Run inference
python isaaclab/scripts/reinforcement_learning/rsl_rl/play.py \
    --task="$TASK" \
    --num_envs $NUM_ENVS \
    $LIVESTREAM_PARAM \
    --rendering_mode balanced \
    --device cuda \
    $RESUME \
    $LOAD_RUN \
    $CHECKPOINT
