#!/usr/bin/env bash
# Isaac Sim compatibility_check shell

# release is From https://docs.isaacsim.omniverse.nvidia.com/latest/installation/download.html#latest-release
cd scripts
mkdir -p checker
cd checker

if [ ! -f "omni.isaac.sim.compatibility_check.sh" ]; then
    echo "compatibility_check.sh does not exist,downloading..."
    wget -O checker.zip https://download.isaacsim.omniverse.nvidia.com/isaac-sim-comp-check-5.0.0-linux-x86_64.zip
    unzip checker.zip
fi

# method is from https://docs.isaacsim.omniverse.nvidia.com/latest/installation/quick-install.html#quick-install
bash omni.isaac.sim.compatibility_check.sh
