#!/usr/bin/env sh
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

set -e
apk add --no-cache aws-cli
apk add --no-cache jq
printenv
aws sts get-caller-identity
STS_CREDS=$(aws sts assume-role --role-arn "${ROLE_TO_ASSUME}" --role-session-name "${AWS_ROLE_SESSION_NAME}")
unset AWS_ACCESS_KEY_ID  AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
AWS_ACCESS_KEY_ID=$(echo "$STS_CREDS" | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo "$STS_CREDS" | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo "$STS_CREDS" | jq -r '.Credentials.SessionToken')
export AWS_ACCESS_KEY_ID  AWS_SECRET_ACCESS_KEY AWS_SESSION_TOKEN
aws sts get-caller-identity
driftctl scan --only-managed  --from tfstate+s3://"${BACKEND_BUCKET_NAME}"/*.tfstate
