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

set -o errexit -o nounset -o pipefail

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

# Set Starterkit version
STARTER_KIT_CURRENT_VERSION_PATH=".STARTER_KIT_CURRENT_VERSION"
touch $STARTER_KIT_CURRENT_VERSION_PATH

# Check if the file exists and is not empty
if [ -s "$STARTER_KIT_CURRENT_VERSION_PATH" ]; then
    # Read the content of the file into the variable
    STARTER_KIT_VERSION=$(<"$STARTER_KIT_CURRENT_VERSION_PATH")
else
    # Use the default value if the file is empty or does not exist
    STARTER_KIT_VERSION="${1:-latest}"
fi

STARTER_KIT_PROJECT="${2:-Orange-OpenSource/AWSTerraformStarterKit}"

STARTER_KIT_FORMAT="tar"
STARTER_KIT_URL="https://api.github.com/repos/${STARTER_KIT_PROJECT}"
STARTER_KIT_LOCATION="${STARTER_KIT_URL}/${STARTER_KIT_FORMAT}ball/${STARTER_KIT_VERSION}"

if [ "$STARTER_KIT_VERSION" == "latest" ]; then
    if [ -z "$GITHUB_AUTH_TOKEN" ]; then
        # If the token is not set, execute curl without authentication
        STARTER_KIT_LOCATION=$(curl -s "${STARTER_KIT_URL}/releases/latest" | jq -r ".${STARTER_KIT_FORMAT}ball_url")
    else
        # If the variable exists, use the token in the curl command
        STARTER_KIT_LOCATION=$(curl -s -H "Authorization: token $GITHUB_AUTH_TOKEN" "${STARTER_KIT_URL}/releases/latest" | jq -r ".${STARTER_KIT_FORMAT}ball_url")
    fi
fi

if [ -z "$GITHUB_AUTH_TOKEN" ]; then
    # If the token is not set, execute curl without authentication
    LAST_PUBLISH_VERSION=$(curl -s "${STARTER_KIT_URL}/releases/latest" | jq -r ".tag_name")
else
    # If the variable exists, use the token in the curl command
    LAST_PUBLISH_VERSION=$(curl -s -H "Authorization: token $GITHUB_AUTH_TOKEN" "${STARTER_KIT_URL}/releases/latest" | jq -r ".tag_name")
fi

printf "Download StarterKit from: ${STARTER_KIT_LOCATION}\n"

if [ -z "$GITHUB_AUTH_TOKEN" ]; then
    # If the token is not set, execute curl without authentication
    curl --fail -L --progress-bar "${STARTER_KIT_LOCATION}" | tar -xz --strip-components 1
else
    # If the variable exists, use the token in the curl command
    curl --fail -L --progress-bar -H "Authorization: token $GITHUB_AUTH_TOKEN" "${STARTER_KIT_LOCATION}" | tar -xz --strip-components 1
fi

STARTER_KIT_VERSION=${STARTER_KIT_LOCATION##*/}

if [ "$STARTER_KIT_VERSION" == "$LAST_PUBLISH_VERSION" ]; then
  printf "Downloaded StaterKit Version ${GREEN}${STARTER_KIT_VERSION}${NC}\n"
else
  printf "Downloaded StaterKit Version ${RED}${STARTER_KIT_VERSION}${NC}, the last published version available is ${RED}${LAST_PUBLISH_VERSION}${NC}\n"
fi

echo "${STARTER_KIT_VERSION}" > "${STARTER_KIT_CURRENT_VERSION_PATH}"
