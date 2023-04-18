#!/bin/bash
#
# Environment configuration for redis-cluster

# The values for all environment variables will be set in the below order of precedence
# 1. Custom environment variables defined below after Bitnami defaults
# 2. Constants defined in this file (environment variables with no default), i.e. BITNAMI_ROOT_DIR
# 3. Environment variables overridden via external files using *_FILE variables (see below)
# 4. Environment variables set externally (i.e. current Bash context/Dockerfile/userdata)

# Load logging library
# shellcheck disable=SC1090,SC1091
# 加载日志库
. /opt/bitnami/scripts/liblog.sh

# bitnami 根目录
export BITNAMI_ROOT_DIR="/opt/bitnami"

# bitnami数据目录
export BITNAMI_VOLUME_DIR="/bitnami"

# Logging configuration
export MODULE="${MODULE:-redis-cluster}"
export BITNAMI_DEBUG="${BITNAMI_DEBUG:-false}"

# By setting an environment variable matching *_FILE to a file path, the prefixed environment
# variable will be overridden with the value specified in that file
redis_cluster_env_vars=(
    REDIS_DATA_DIR
    REDIS_OVERRIDES_FILE
    REDIS_DISABLE_COMMANDS
    REDIS_DATABASE
    REDIS_AOF_ENABLED
    REDIS_MASTER_HOST
    REDIS_MASTER_PORT_NUMBER
    REDIS_PORT_NUMBER
    REDIS_ALLOW_REMOTE_CONNECTIONS
    REDIS_REPLICATION_MODE
    REDIS_REPLICA_IP
    REDIS_REPLICA_PORT
    REDIS_EXTRA_FLAGS
    ALLOW_EMPTY_PASSWORD
    REDIS_PASSWORD
    REDIS_MASTER_PASSWORD
    REDIS_ACLFILE
    REDIS_IO_THREADS_DO_READS
    REDIS_IO_THREADS
    REDIS_TLS_ENABLED
    REDIS_TLS_PORT_NUMBER
    REDIS_TLS_CERT_FILE
    REDIS_TLS_KEY_FILE
    REDIS_TLS_KEY_FILE_PASS
    REDIS_TLS_CA_FILE
    REDIS_TLS_DH_PARAMS_FILE
    REDIS_TLS_AUTH_CLIENTS
    REDIS_CLUSTER_CREATOR
    REDIS_CLUSTER_REPLICAS
    REDIS_CLUSTER_DYNAMIC_IPS
    REDIS_CLUSTER_ANNOUNCE_IP
    REDIS_CLUSTER_ANNOUNCE_PORT
    REDIS_CLUSTER_ANNOUNCE_BUS_PORT
    REDIS_DNS_RETRIES
    REDIS_NODES
    REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP
    REDIS_CLUSTER_DNS_LOOKUP_RETRIES
    REDIS_CLUSTER_DNS_LOOKUP_SLEEP
    REDIS_CLUSTER_ANNOUNCE_HOSTNAME
    REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE
    REDIS_TLS_PORT
)

# 容器启动后，设置环境变量后，这些变量可以直接从环境变量内读取
for env_var in "${redis_cluster_env_vars[@]}"; do
    # REDIS_TLS_CA_FILE -> REDIS_TLS_CA_FILE_FILE
    # REDIS_TLS_PORT -> REDIS_TLS_PORT_FILE
    file_env_var="${env_var}_FILE"

    # 判断环境变量是否存在${env_var}_FILE这个变量
    if [[ -n "${!file_env_var:-}" ]]; then
        # 判断${env_var}_FILE这个文件是否可读
        if [[ -r "${!file_env_var:-}" ]]; then
            # 将文件内容导入到这个变量内部
            export "${env_var}=$(< "${!file_env_var}")"
            unset "${file_env_var}"
        else
            warn "Skipping export of '${env_var}'. '${!file_env_var:-}' is not readable."
        fi
    fi
done
unset redis_cluster_env_vars

# bitnami 根目录
export BITNAMI_ROOT_DIR="/opt/bitnami"
# bitnami数据目录
export BITNAMI_VOLUME_DIR="/bitnami"

# Paths
export REDIS_VOLUME_DIR="/bitnami/redis"

# /opt/bitnami/redis
export REDIS_BASE_DIR="${BITNAMI_ROOT_DIR}/redis"

# /opt/bitnami/redis/etc
export REDIS_CONF_DIR="${REDIS_BASE_DIR}/etc"

export REDIS_DATA_DIR="${REDIS_DATA_DIR:-${REDIS_VOLUME_DIR}/data}"

# /opt/bitnami/redis/mounted-etc
export REDIS_MOUNTED_CONF_DIR="${REDIS_BASE_DIR}/mounted-etc"

export REDIS_OVERRIDES_FILE="${REDIS_OVERRIDES_FILE:-${REDIS_MOUNTED_CONF_DIR}/overrides.conf}"
export REDIS_CONF_FILE="${REDIS_CONF_DIR}/redis.conf"
export REDIS_LOG_DIR="${REDIS_BASE_DIR}/logs"
export REDIS_LOG_FILE="${REDIS_LOG_DIR}/redis.log"
export REDIS_TMP_DIR="${REDIS_BASE_DIR}/tmp"
export REDIS_PID_FILE="${REDIS_TMP_DIR}/redis.pid"
export REDIS_BIN_DIR="${REDIS_BASE_DIR}/bin"
export PATH="${REDIS_BIN_DIR}:${BITNAMI_ROOT_DIR}/common/bin:${PATH}"

# System users (when running with a privileged user)
export REDIS_DAEMON_USER="redis"
export REDIS_DAEMON_GROUP="redis"

# Redis settings
# Disables the specified Redis(R) commands
export REDIS_DISABLE_COMMANDS="${REDIS_DISABLE_COMMANDS:-}"

export REDIS_DATABASE="${REDIS_DATABASE:-redis}"
export REDIS_AOF_ENABLED="${REDIS_AOF_ENABLED:-yes}"
export REDIS_MASTER_HOST="${REDIS_MASTER_HOST:-}"
export REDIS_MASTER_PORT_NUMBER="${REDIS_MASTER_PORT_NUMBER:-6379}"
export REDIS_DEFAULT_PORT_NUMBER="6379" # only used at build time

# Set the Redis(R) port. Default=: `6379`   
export REDIS_PORT_NUMBER="${REDIS_PORT_NUMBER:-$REDIS_DEFAULT_PORT_NUMBER}"

export REDIS_ALLOW_REMOTE_CONNECTIONS="${REDIS_ALLOW_REMOTE_CONNECTIONS:-yes}"

export REDIS_REPLICATION_MODE="${REDIS_REPLICATION_MODE:-}"

export REDIS_REPLICA_IP="${REDIS_REPLICA_IP:-}"
export REDIS_REPLICA_PORT="${REDIS_REPLICA_PORT:-}"
export REDIS_EXTRA_FLAGS="${REDIS_EXTRA_FLAGS:-}"

# default disable empty password
# Enables access without password
export ALLOW_EMPTY_PASSWORD="${ALLOW_EMPTY_PASSWORD:-no}"

# Set the Redis(R) password. Default: `bitnami`
export REDIS_PASSWORD="${REDIS_PASSWORD:-}"
export REDIS_MASTER_PASSWORD="${REDIS_MASTER_PASSWORD:-}"
export REDIS_ACLFILE="${REDIS_ACLFILE:-}"

# Enables multithreading for read operations. Defaults to `false`
export REDIS_IO_THREADS_DO_READS="${REDIS_IO_THREADS_DO_READS:-}"

# Number of threads to implement multithreading operations. Defaults to `1`
export REDIS_IO_THREADS="${REDIS_IO_THREADS:-}"

# TLS settings
# Whether to enable TLS for traffic or not. Defaults to `no`.
export REDIS_TLS_ENABLED="${REDIS_TLS_ENABLED:-no}"

REDIS_TLS_PORT_NUMBER="${REDIS_TLS_PORT_NUMBER:-"${REDIS_TLS_PORT:-}"}"

# Port used for TLS secure traffic. Defaults to `6379`.
export REDIS_TLS_PORT_NUMBER="${REDIS_TLS_PORT_NUMBER:-6379}"

# File containing the certificate file for the TLS traffic. No defaults.
export REDIS_TLS_CERT_FILE="${REDIS_TLS_CERT_FILE:-}"

#  File containing the key for certificate. No defaults
export REDIS_TLS_KEY_FILE="${REDIS_TLS_KEY_FILE:-}"

export REDIS_TLS_KEY_FILE_PASS="${REDIS_TLS_KEY_FILE_PASS:-}"

export REDIS_TLS_CA_FILE="${REDIS_TLS_CA_FILE:-}"

# File containing DH params (in order to support DH based ciphers). No defaults
export REDIS_TLS_DH_PARAMS_FILE="${REDIS_TLS_DH_PARAMS_FILE:-}"

# Whether to require clients to authenticate or not. Defaults to `yes`.
export REDIS_TLS_AUTH_CLIENTS="${REDIS_TLS_AUTH_CLIENTS:-yes}"

# Redis Cluster settings
# default no
# Set to `yes` if the container will be the one on charge of initialize the cluster. This node will also be part of the cluster
export REDIS_CLUSTER_CREATOR="${REDIS_CLUSTER_CREATOR:-no}"

# Number of replicas for every master that the cluster will have
export REDIS_CLUSTER_REPLICAS="${REDIS_CLUSTER_REPLICAS:-1}"

# Set to `no` if your Redis(R) cluster will be created with statical IPs. Default: `yes`
export REDIS_CLUSTER_DYNAMIC_IPS="${REDIS_CLUSTER_DYNAMIC_IPS:-yes}"

# IP that the node should announce, used for non dynamic ip environments
export REDIS_CLUSTER_ANNOUNCE_IP="${REDIS_CLUSTER_ANNOUNCE_IP:-}"

# Port that the node should announce, used for non dynamic ip environments
export REDIS_CLUSTER_ANNOUNCE_PORT="${REDIS_CLUSTER_ANNOUNCE_PORT:-}"

# The cluster bus port to announce
export REDIS_CLUSTER_ANNOUNCE_BUS_PORT="${REDIS_CLUSTER_ANNOUNCE_BUS_PORT:-}"

# Number of retries to get the IPs of the provided `REDIS_NODES`. It will wait 5 seconds between retries
export REDIS_DNS_RETRIES="${REDIS_DNS_RETRIES:-120}"

# default null
# String delimited by spaces containing the hostnames of all of the nodes that will be part of the cluster
export REDIS_NODES="${REDIS_NODES:-}"

# Number of seconds to wait before initializing the cluster. Set this to a higher value if you sometimes have issues with initial cluster creation. Defaults to `0`.
export REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP="${REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP:-0}"

# Number of retries for the node's DNS lookup during the initial cluster creation. Defaults to `5`
export REDIS_CLUSTER_DNS_LOOKUP_RETRIES="${REDIS_CLUSTER_DNS_LOOKUP_RETRIES:-1}"

# Number of seconds to wait between each node's DNS lookup during the initial cluster creation. Defaults to `1`
export REDIS_CLUSTER_DNS_LOOKUP_SLEEP="${REDIS_CLUSTER_DNS_LOOKUP_SLEEP:-1}"

# Hostname that node should announce, used for non dynamic ip environments.
export REDIS_CLUSTER_ANNOUNCE_HOSTNAME="${REDIS_CLUSTER_ANNOUNCE_HOSTNAME:-}"

# Preferred endpoint type which cluster should use, options- ip, hostname 
export REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE="${REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE:-ip}"

# Custom environment variables may be defined below