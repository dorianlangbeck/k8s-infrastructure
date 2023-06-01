#!/bin/bash
set -e -o pipefail

if [ $# -ne 1 ]; then
    echo >&2 "Usage: ${0} <new-tag>"
    exit 1
fi

NEW_TAG="${1}"

git checkout apps/rollout-exp/kustomization.yaml
sed -i "s/newTag:.*/newTag: ${NEW_TAG}/" apps/rollout-exp/kustomization.yaml
git add apps/rollout-exp/kustomization.yaml
git diff --staged
git commit -m 'Update tag name'
git push -q
