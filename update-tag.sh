#!/bin/bash
set -e -o pipefail

SUPPORTED_COLORS=(red orange yellow green blue purple)

show_usage_and_exit() {
    echo >&2 "Usage: ${0} <color-tag>"
    echo >&2 "Supported colors are: ${SUPPORTED_COLORS[@]}"
    exit 1
}

[ $# -ne 1 ] && show_usage_and_exit

NEW_TAG="${1}"
found=0
for color in "${SUPPORTED_COLORS[@]}"; do
    if [[ "${color}" == "${NEW_TAG}" ]]; then
        found=1
        break
    fi
done

[ "${found}" -eq 0 ] && show_usage_and_exit


git checkout apps/rollout-exp/kustomization.yaml
sed -i "s/newTag:.*/newTag: ${NEW_TAG}/" apps/rollout-exp/kustomization.yaml
git add apps/rollout-exp/kustomization.yaml
git diff --staged
git commit -m 'Update tag name'
git push -q
