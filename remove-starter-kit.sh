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

ls -a | grep -xvi ".gitignore\|.git\|.idea\|terraform\|README.md\|configure.yaml\|configure.yaml.dist\|get-starter-kit.sh\|remove-starter-kit.sh" | xargs  rm -rfv
