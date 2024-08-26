#!/usr/bin/env bash

#
# // Software Name : AWSTerraformStarterKit
# // SPDX-FileCopyrightText: Copyright (c) 2023 Orange Business
# // SPDX-License-Identifier: BSD-3-Clause
# //
# // This software is distributed under the BSD License;
# // see the LICENSE file for more details.
# //
# // Author: AWS Practice Team <awspractice.core@orange.com>
#

set -o errexit
set -o nounset
set -o pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

GITHUB_AUTH_TOKEN="${GITHUB_AUTH_TOKEN:-}"

# Check for required dependencies
command -v curl >/dev/null 2>&1 || { echo -e "${RED}Error: curl is not installed.${NC}" >&2; exit 1; }
command -v jq >/dev/null 2>&1 || { echo -e "${RED}Error: jq is not installed.${NC}" >&2; exit 1; }
command -v tar >/dev/null 2>&1 || { echo -e "${RED}Error: tar is not installed.${NC}" >&2; exit 1; }

if [ -z "$GITHUB_AUTH_TOKEN" ]; then
    printf "${RED}GITHUB_AUTH_TOKEN is not set.${NC}\n"
else
    printf "${GREEN}GITHUB_AUTH_TOKEN is set.${NC}\n"
fi

# Set Starter Kit version
STARTER_KIT_CURRENT_VERSION_PATH=".STARTER_KIT_CURRENT_VERSION"

# Check if the file exists and is not empty
if [ -s "$STARTER_KIT_CURRENT_VERSION_PATH" ]; then
    # Read the content of the file into the variable
    STARTER_KIT_VERSION=$(<"$STARTER_KIT_CURRENT_VERSION_PATH")
else
    # Use the default value if the file is empty or does not exist
    STARTER_KIT_VERSION="latest"
fi

# Set the Starter Kit project and URL
STARTER_KIT_PROJECT="Orange-OpenSource/AWSTerraformStarterKit"
STARTER_KIT_URL="https://api.github.com/repos/${STARTER_KIT_PROJECT}"

# Get the latest published version (including drafts and prereleases)
if [ -z "$GITHUB_AUTH_TOKEN" ]; then
    LAST_PUBLISH_VERSION=$(curl -s "${STARTER_KIT_URL}/releases" | jq -r 'sort_by(.created_at) | last | .tag_name')
else
    LAST_PUBLISH_VERSION=$(curl -s -H "Authorization: token $GITHUB_AUTH_TOKEN" "${STARTER_KIT_URL}/releases" | jq -r 'sort_by(.created_at) | last | .tag_name')
fi

# Output the Starter Kit version comparison
if [ "$STARTER_KIT_VERSION" == "$LAST_PUBLISH_VERSION" ]; then
    printf "You are using the last published version ${GREEN}%s${NC}\n" "$STARTER_KIT_VERSION"
else
    printf "You are not using the last Starter Kit version ${RED}%s${NC}, the last published version available is ${RED}%s${NC}\n" "$STARTER_KIT_VERSION" "$LAST_PUBLISH_VERSION"
fi
