#!/bin/bash

# shellcheck disable=SC1091

set -o errexit
set -o nounset
set -o pipefail
# set -o xtrace # Uncomment this line for debugging purposes

# Load Redis environment variables
. /opt/bitnami/scripts/redis-cluster-env.sh

# Load libraries
# 欢迎信息与log
. /opt/bitnami/scripts/libbitnami.sh


# 集群库函数脚本
. /opt/bitnami/scripts/librediscluster.sh

print_welcome_page

if [[ "$*" = *"/run.sh"* ]]; then
    info "** Starting Redis setup **"
    /opt/bitnami/scripts/redis-cluster/setup.sh
    info "** Redis setup finished! **"
fi

echo ""
exec "$@"
