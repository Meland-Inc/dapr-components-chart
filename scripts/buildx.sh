#!/bin/bash

# 运行cmcli
set -o errexit
set -o nounset
set -o pipefail

readonly PROJECT_ROOT=$(pwd)

# 添加 aws charts 源
helm repo add melands3 s3://meland-helm-charts/meland

# 压缩charts 准备上传
projects=$(find "${PROJECT_ROOT}/dapr-charts" -type dir -maxdepth 1 | xargs -I {} basename {});
for project in $projects
do
    if [[ -d "${PROJECT_ROOT}/dapr-charts/${project}" ]];
    then
        helm package ${PROJECT_ROOT}/dapr-charts/${project}/charts/${project} -d "${PROJECT_ROOT}/.chartsp"
    fi
done

# 上传所有目录下的charts包
charts=$(find "${PROJECT_ROOT}/.chartsp" -type file -maxdepth 1 | xargs -I {} basename {});
for chart in ${charts}
do
    helm s3 push --force "${PROJECT_ROOT}/.chartsp/${chart}" melands3
done

echo "发布成功👌"
