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

# Set Starterkit version
starter_kit_current_version_path=".STARTER_KIT_CURRENT_VERSION"
touch $starter_kit_current_version_path

# Check if the file exists and is not empty
if [ -s "$starter_kit_current_version_path" ]; then
    # Read the content of the file into the variable
    STARTER_KIT_VERSION=$(<"$starter_kit_current_version_path")
else
    # Use the default value if the file is empty or does not exist
    STARTER_KIT_VERSION="${1:-latest}"
fi

STARTER_KIT_PROJECT="${2:-Orange-OpenSource/AWSTerraformStarterKit}"

STARTER_KIT_FORMAT="tar"
STARTER_KIT_URL="https://api.github.com/repos/${STARTER_KIT_PROJECT}"
STARTER_KIT_LOCATION="${STARTER_KIT_URL}/${STARTER_KIT_FORMAT}ball/${STARTER_KIT_VERSION}"

if [ "$STARTER_KIT_VERSION" == "latest" ]; then
    STARTER_KIT_LOCATION=$(curl -s ${STARTER_KIT_URL}/releases/latest | jq -r ".${STARTER_KIT_FORMAT}ball_url")
fi

echo "Download StarterKit from: ${STARTER_KIT_LOCATION}"

curl --fail -L "${STARTER_KIT_LOCATION}" | tar -xz --strip-components 1

STARTER_KIT_VERSION=${STARTER_KIT_LOCATION##*/}

echo "StaterKit Version ${STARTER_KIT_VERSION}"

echo "${STARTER_KIT_VERSION}" > $starter_kit_current_version_path
