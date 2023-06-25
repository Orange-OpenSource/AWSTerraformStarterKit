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
STARTER_KIT_VERSION="${1:-latest}"
STARTER_KIT_PROJECT="${2:-Orange-OpenSource/AWSTerraformStarterKit}"

STARTER_KIT_FORMAT="zip"
STARTER_KIT_URL="https://github.com/${STARTER_KIT_PROJECT}"

if [ "$STARTER_KIT_VERSION" == "latest" ]; then
    STARTER_KIT_VERSION=$(curl -s "https://api.github.com/repos/${STARTER_KIT_PROJECT}/releases/latest" | jq -r ".tag_name")
fi

STARTER_KIT_LOCATION="${STARTER_KIT_URL}/archive/refs/tags/${STARTER_KIT_VERSION}.${STARTER_KIT_FORMAT}"
curl --fail -L "${STARTER_KIT_LOCATION}" -o /tmp/archive.zip

unzip /tmp/archive.zip -d .
cp -r AWSTerraformStarterKit-*/. .
rm -rf AWSTerraformStarterKit-*
rm /tmp/archive.zip
