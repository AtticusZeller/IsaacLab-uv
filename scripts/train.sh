#!/usr/bin/env bash

# Available task list
TASKS=(
"Isaac-Velocity-Rough-G1-v0"
"Isaac-Velocity-Rough-H1-v0"
"Isaac-Velocity-Rough-Anymal-D-v0"
"Isaac-Velocity-Rough-Unitree-Go2-v0"
)

# Parse parameters
TASK=""
RUN_NAME=""

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
            echo "❌ Unknown parameter: $1"
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
    echo "💡 Usage: $0 --task Isaac-Velocity-Rough-G1-v0 [--run_name MyRun]"
    exit 1
fi

# If run_name is not specified, generate it from the task automatically
if [ -z "$RUN_NAME" ]; then
    # Extract the part after Isaac-, remove -v0
RUN_NAME=$(echo "$TASK" | sed 's/Isaac-//;s/-v[0-9]$//')
fi

echo "🚀 Starting training"
echo "📦 Task: $TASK"
echo "🏷️  Run Name: $RUN_NAME"
echo ""

# Execute training
python isaaclab/scripts/reinforcement_learning/rsl_rl/train.py \
    --task="$TASK" \
    --headless \
    --logger wandb \
    --run_name "$RUN_NAME" \
    --log_project_name isaaclab
