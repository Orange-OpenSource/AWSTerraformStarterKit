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
STARTER_KIT_VERSION="v0.0.8"

# Set GitLab URL and GitLab project ID (AWS Terraform StarterKit porject ID)
GITLAB_URL="git.mydomain.com"
GITLAB_PROJECT_ID="27"

# Set GitLab HTTP token
GITLAB_TOKEN="YOUR_GITLAB_HTTP_TOKEN"

curl --header "PRIVATE-TOKEN: ${GITLAB_TOKEN}" \
"https://${GITLAB_URL}/api/v4/projects/${GITLAB_PROJECT_ID}/repository/archive.zip?sha=${STARTER_KIT_VERSION}" \
-o /tmp/archive.zip

unzip /tmp/archive.zip -d .
cp -r awsterraformstarterkit-*/. .
rm -rf awsterraformstarterkit-*
rm /tmp/archive.zip
