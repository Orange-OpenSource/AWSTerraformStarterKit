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

STARTER_KIT_FORMAT="tar"
STARTER_KIT_URL="https://api.github.com/repos/${STARTER_KIT_PROJECT}"
STARTER_KIT_LOCATION="${STARTER_KIT_URL}/${STARTER_KIT_FORMAT}ball/${STARTER_KIT_VERSION}"

if [ "$STARTER_KIT_VERSION" == "latest" ]; then
    STARTER_KIT_LOCATION=$(curl -s ${STARTER_KIT_URL}/releases/latest | jq -r ".${STARTER_KIT_FORMAT}ball_url")
fi

curl --fail -L "${STARTER_KIT_LOCATION}" | tar -xz --strip-components 1

STARTER_KIT_VERSION=${STARTER_KIT_LOCATION##*/}
echo "${STARTER_KIT_VERSION}" > STARTER_KIT_VERSION

