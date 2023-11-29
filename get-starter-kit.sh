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
    STARTER_KIT_LOCATION=$(curl -s "${STARTER_KIT_URL}/releases/latest" | jq -r ".${STARTER_KIT_FORMAT}ball_url")
fi

LAST_PUBLISH_VERSION=$(curl -s "${STARTER_KIT_URL}/releases/latest" | jq -r ".tag_name")

printf "Download StarterKit from: ${STARTER_KIT_LOCATION}\n"

curl --fail -L --progress-bar "${STARTER_KIT_LOCATION}" | tar -xz --strip-components 1

STARTER_KIT_VERSION=${STARTER_KIT_LOCATION##*/}

if [ "$STARTER_KIT_VERSION" == "$LAST_PUBLISH_VERSION" ]; then
  printf "Downloaded StaterKit Version ${GREEN}${STARTER_KIT_VERSION}${NC}\n"
else
  printf "Downloaded StaterKit Version ${RED}${STARTER_KIT_VERSION}${NC}, the last published version available is ${RED}${LAST_PUBLISH_VERSION}${NC}\n"
fi

echo "${STARTER_KIT_VERSION}" > "${STARTER_KIT_CURRENT_VERSION_PATH}"
