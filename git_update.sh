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
else
  echo "No version change needed."
  exit 0
fi

echo "Detected Version Bump: $VERSION"

# get highest tag number, and add v0.1.0 if doesn't exist
git fetch --prune --unshallow 2>/dev/null
CURRENT_VERSION=$(git describe --abbrev=0 --tags 2>/dev/null)

if [[ -z "$CURRENT_VERSION" ]]; then
  CURRENT_VERSION="v0.1.0"
fi
echo "Current Version: $CURRENT_VERSION"

IFS='.' read -ra CURRENT_VERSION_PARTS <<< "${CURRENT_VERSION//v/}"
VNUM1=${CURRENT_VERSION_PARTS[0]}
VNUM2=${CURRENT_VERSION_PARTS[1]}
VNUM3=${CURRENT_VERSION_PARTS[2]}


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
else
  echo "Invalid version type."
  exit 1
fi

# create new tag
NEW_TAG="$VNUM1.$VNUM2.$VNUM3"
echo "($VERSION) updating $CURRENT_VERSION to $NEW_TAG"

# get current hash and see if it already has a tag
GIT_COMMIT=`git rev-parse HEAD`
NEEDS_TAG=`git describe --contains $GIT_COMMIT 2>/dev/null`

# only tag if no tag already
if [ -z "$NEEDS_TAG" ]; then
  echo "Tagged with $NEW_TAG"
  git tag $NEW_TAG
  git push --tags
  git push
else
  echo "Already a tag on this commit"
fi

echo ::set-output name=git-tag::$NEW_TAG

exit 0
