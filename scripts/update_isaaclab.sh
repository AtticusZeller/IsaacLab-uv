#!/usr/bin/env bash

echo "Entering isaaclab submodule..."
cd isaaclab || exit

echo "Fetching tags..."
git fetch --tags

LATEST_TAG=$(git tag --sort=-v:refname | head -n 1)
echo "Found latest tag: $LATEST_TAG"

git checkout "$LATEST_TAG"

cd ..

echo "Committing changes to parent repo..."

git add isaaclab
git commit -m "Update isaaclab submodule to tag $LATEST_TAG"

echo "Done! IsaacLab is now at $LATEST_TAG"
