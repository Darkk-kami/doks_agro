#!/bin/bash

LAST_COMMIT=$(git log -1 --pretty=%B)
echo "Last Commit Message: $LAST_COMMIT"

# Determine the version bump type based on commit message
if [[ "$LAST_COMMIT" == *"feat!"* ]]; then
  VERSION="major"
elif [[ "$LAST_COMMIT" == *"feat"* ]]; then
  VERSION="minor"
elif [[ "$LAST_COMMIT" == *"fix"* ]]; then
  VERSION="patch"
fi

# Default to patch if no valid type found
if [[ -z "$VERSION" ]]; then
  VERSION="patch"
  echo "No version bump detected, defaulting to patch."
fi

echo "Detected Version Bump: $VERSION"

# Fetch latest tags
git fetch --tags --prune 2>/dev/null
CURRENT_VERSION=$(git describe --tags --abbrev=0 2>/dev/null)

if [[ -z "$CURRENT_VERSION" || "$CURRENT_VERSION" == "fatal: No names found"* ]]; then
  echo "No tags found. Defaulting to v0.1.0."
  CURRENT_VERSION="v0.1.0"
  git tag "$CURRENT_VERSION"
  git push --tags
fi

echo "Current Version: $CURRENT_VERSION"

# Parse version numbers
IFS='.' read -ra CURRENT_VERSION_PARTS <<< "${CURRENT_VERSION#v}"
VNUM1=${CURRENT_VERSION_PARTS[0]:-0}
VNUM2=${CURRENT_VERSION_PARTS[1]:-1}
VNUM3=${CURRENT_VERSION_PARTS[2]:-0}

# Bump the correct version number
if [[ "$VERSION" == "major" ]]; then
  VNUM1=$((VNUM1 + 1))
  VNUM2=0
  VNUM3=0
elif [[ "$VERSION" == "minor" ]]; then
  VNUM2=$((VNUM2 + 1))
  VNUM3=0
elif [[ "$VERSION" == "patch" ]]; then
  VNUM3=$((VNUM3 + 1))
fi

# Create new tag
NEW_TAG="v$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_TAG"

# Check if the commit is already tagged
GIT_COMMIT=$(git rev-parse HEAD)
NEEDS_TAG=$(git describe --contains "$GIT_COMMIT" 2>/dev/null)

if [[ -z "$NEEDS_TAG" ]]; then
  echo "Tagged with $NEW_TAG"
  git tag "$NEW_TAG"
  git push --tags
  git push
else
  echo "Already a tag on this commit"
fi

# GitHub Actions output
echo "git-tag=$NEW_TAG" >> $GITHUB_ENV

exit 0
