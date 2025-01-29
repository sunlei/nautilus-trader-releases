#!/usr/bin/env bash
set -euo pipefail

# Format: {semver}.dev{date}+{build_number}.cpu.{target_cpu}
# Example: 1.208.0.dev20251212+7001.cpu.sapphirerapids

base_version=$(yq -r '.tool.poetry.version' src/pyproject.toml)

dev_version="dev$(date -u +%Y%m%d)+${GITHUB_RUN_NUMBER}"
release_version=${base_version}.${dev_version}
local_version_cpu="cpu.${TARGET_CPU}"

if [ "${TARGET_CPU}" == "" ]; then
  new_version="${release_version}"
else
  new_version="${release_version}.${local_version_cpu}"
fi

poetry version --directory=src "${new_version}"
echo "RELEASE_VERSION=${release_version}" >>"$GITHUB_ENV"

echo "Set version to ${new_version}"
