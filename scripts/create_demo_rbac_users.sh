#!/usr/bin/env bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Bash safeties: exit on error, no unset variables, pipelines can't hide errors
set -o errexit
set -o pipefail

# Locate the root directory
ROOT="$( cd "$( dirname "${BASH_SOURCE[0]}" )/.." && pwd )"

# shellcheck source=scripts/common.sh
source "${ROOT}/scripts/common.sh"

declare -a k8s_users=( 
            rbac-demo-auditor:view
            rbac-demo-editor:edit
            )

for k8s_user in "${k8s_users[@]}"
do
    name="${k8s_user%%:*}"
    role="${k8s_user##*:}"

    printf "%s likes to %s.\n" "$name" "$role"
done
