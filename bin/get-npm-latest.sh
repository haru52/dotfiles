#!/bin/sh

# Print the latest stable version of an npm package.
# If a major version is given, restrict the search to that major version.
# Pre-release versions (e.g., 1.0.0-beta.1) are always ignored.
#
# Usage: get-npm-latest <package-name> [major-version]
#
# Examples:
#   get-npm-latest react      # latest stable, e.g., 19.2.8
#   get-npm-latest react 17   # latest stable 17.x, e.g., 17.0.2

set -eu

usage() {
  echo "Usage: ${0##*/} <package-name> [major-version]"
}

case "${1:-}" in
  -h | --help)
    usage
    exit 0
    ;;
  *) ;;
esac

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  usage >&2
  exit 1
fi

package_name=$1
major_version=${2:-}

if [ -z "${package_name}" ]; then
  echo "Error: package-name must not be empty" >&2
  exit 1
fi

# major-version must be a non-negative integer without leading zeros
if [ -n "${major_version}" ]; then
  case "${major_version}" in
    *[!0-9]* | 0?*)
      echo "Error: major-version must be a non-negative integer: ${major_version}" >&2
      exit 1
      ;;
    *) ;;
  esac
fi

if ! command -v npm > /dev/null 2>&1; then
  echo "Error: npm is not installed" >&2
  exit 1
fi

# JSON array of all published versions, e.g., ["1.0.0", "1.1.0-beta.1", ...]
# (npm prints a bare string instead of an array when only one version exists)
if ! all_versions=$(npm view "${package_name}" versions --json); then
  echo "Error: failed to fetch versions of '${package_name}'" >&2
  exit 1
fi

# Only strict X.Y.Z versions are considered stable
if [ -n "${major_version}" ]; then
  version_pattern="^${major_version}\\.[0-9]+\\.[0-9]+$"
else
  version_pattern='^[0-9]+\.[0-9]+\.[0-9]+$'
fi

# Strip JSON syntax, keep stable versions only and pick the highest one
latest_version=$(
  printf '%s\n' "${all_versions}" \
    | tr -d '[]", ' \
    | grep -E "${version_pattern}" \
    | sort -t . -k 1,1n -k 2,2n -k 3,3n \
    | tail -n 1
)

if [ -z "${latest_version}" ]; then
  if [ -n "${major_version}" ]; then
    echo "Error: no stable ${major_version}.x.x version of '${package_name}' found" >&2
  else
    echo "Error: no stable version of '${package_name}' found" >&2
  fi
  exit 1
fi

echo "${latest_version}"
