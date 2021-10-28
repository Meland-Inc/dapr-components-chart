#!/bin/bash

# 运行cmcli
set -o errexit
set -o nounset
set -o pipefail

tmp_dir=$(dirname $(dirname "${BASH_SOURCE}"))
cd "$tmp_dir"

readonly PROJECT_ROOT=$(pwd)
readonly RUN_ROOT=/$(pwd)
readonly HELM_PEPO_MANAGE_IMAGE=${HELM_PEPO_MANAGE_IMAGE:-"icw-registry.cn-shenzhen.cr.aliyuncs.com/icw/helm-repo-manage"}
readonly PROJECT_NAME="dapr-components";
# helm 仓库地址
readonly HELM_REPO_DOMAIN="acr://icw-chart.cn-shenzhen.cr.aliyuncs.com/icw/icw-dapr"

echo "push ${PROJECT_NAME} with docker ..."

# push chart
docker run --rm \
-v $PROJECT_ROOT:$PROJECT_ROOT \
-e PROJECT_NAME=$PROJECT_NAME \
-e PROJECT_PATH=$PROJECT_ROOT/charts/$PROJECT_NAME \
-e HELM_REPO=$HELM_REPO_DOMAIN \
$HELM_PEPO_MANAGE_IMAGE