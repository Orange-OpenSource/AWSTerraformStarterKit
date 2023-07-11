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

FILE_LIST=".config automation .gitignore.dist docker-compose.yml docker-compose-tools.yml makeplan.mk .env .editorconfig Makefile .gitlab-ci.yml"

for file in $FILE_LIST
do
    [ -f $file ] || [ -d $file ] && echo "$file exists, will be deleted" && rm -r $file
done
