#!/bin/bash
#
# Bitnami Redis Cluster library

# shellcheck disable=SC1090,SC1091

# Load Generic Libraries
. /opt/bitnami/scripts/libfile.sh
. /opt/bitnami/scripts/libfs.sh
. /opt/bitnami/scripts/liblog.sh
. /opt/bitnami/scripts/libnet.sh
. /opt/bitnami/scripts/libos.sh
. /opt/bitnami/scripts/libservice.sh
. /opt/bitnami/scripts/libvalidations.sh
. /opt/bitnami/scripts/libredis.sh

# Functions

########################
# Validate settings in REDIS_* env vars.
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_validate() {
    debug "Validating settings in REDIS_* env vars.."
    local error_code=0

    # Auxiliary functions
    print_validation_error() {
        error "$1"
        error_code=1
    }

    empty_password_enabled_warn() {
        warn "You set the environment variable ALLOW_EMPTY_PASSWORD=${ALLOW_EMPTY_PASSWORD}. For safety reasons, do not use this flag in a production environment."
    }
    empty_password_error() {
        print_validation_error "The $1 environment variable is empty or not set. Set the environment variable ALLOW_EMPTY_PASSWORD=yes to allow the container to be started with blank passwords. This is recommended only for development."
    }

    # redis password validate
    # libvalidations.sh
    # default disable empty password
    if is_boolean_yes "$ALLOW_EMPTY_PASSWORD"; then
        empty_password_enabled_warn
    else
        [[ -z "$REDIS_PASSWORD" ]] && empty_password_error REDIS_PASSWORD
    fi

    # redis cluster ip validate
    if ! is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS"; then
        [[ -z "$REDIS_CLUSTER_ANNOUNCE_IP" ]] && print_validation_error "To provide external access you need to provide the REDIS_CLUSTER_ANNOUNCE_IP env var"
    fi

    # default null
    [[ -z "$REDIS_NODES" ]] && print_validation_error "REDIS_NODES is required"

    # default 6379 if does't define another port
    if [[ -z "$REDIS_PORT_NUMBER" ]]; then
        print_validation_error "REDIS_PORT_NUMBER cannot be empty"
    fi

    # default no
    if is_boolean_yes "$REDIS_CLUSTER_CREATOR"; then
        [[ -z "$REDIS_CLUSTER_REPLICAS" ]] && print_validation_error "To create the cluster you need to provide the number of replicas to the cluster creator"
    fi

    # caculate 
    if ((REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP < 0)); then
        print_validation_error "REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP must be greater or equal to zero"
    fi

    [[ "$error_code" -eq 0 ]] || exit "$error_code"
}

########################
# Redis specific configuration to override the default one
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_override_conf() {
    # Redis configuration to override
    if ! is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS"; then
        redis_conf_set cluster-announce-ip "$REDIS_CLUSTER_ANNOUNCE_IP"
    fi
    if is_boolean_yes "$REDIS_CLUSTER_DYNAMIC_IPS"; then
        # Always set the announce-ip to avoid issues when using proxies and traffic restrictions.
        redis_conf_set cluster-announce-ip "$(get_machine_ip)"
    fi
    if ! is_empty_value "$REDIS_CLUSTER_ANNOUNCE_HOSTNAME"; then
        redis_conf_set "cluster-announce-hostname" "$REDIS_CLUSTER_ANNOUNCE_HOSTNAME"
    fi
    if ! is_empty_value "$REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE"; then
        redis_conf_set "cluster-preferred-endpoint-type" "$REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE"
    fi
    if is_boolean_yes "$REDIS_TLS_ENABLED"; then
        redis_conf_set tls-cluster yes
        redis_conf_set tls-replication yes
    fi
    if ! is_empty_value "$REDIS_CLUSTER_ANNOUNCE_PORT"; then
        redis_conf_set "cluster-announce-port" "$REDIS_CLUSTER_ANNOUNCE_PORT"
    fi
    if ! is_empty_value "$REDIS_CLUSTER_ANNOUNCE_BUS_PORT"; then
        redis_conf_set "cluster-announce-bus-port" "$REDIS_CLUSTER_ANNOUNCE_BUS_PORT"
    fi
    # Multithreading configuration
    if ! is_empty_value "$REDIS_IO_THREADS_DO_READS"; then
        redis_conf_set "io-threads-do-reads" "$REDIS_IO_THREADS_DO_READS"
    fi
    if ! is_empty_value "$REDIS_IO_THREADS"; then
        redis_conf_set "io-threads" "$REDIS_IO_THREADS"
    fi
}

########################
# Ensure Redis is initialized
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
redis_cluster_initialize() {
    redis_configure_default
    redis_cluster_override_conf
}

########################
# Creates the Redis cluster
# Globals:
#   REDIS_*
# Arguments:
#   - $@ Array with the hostnames
# Returns:
#   None
#########################
redis_cluster_create() {
    local nodes=("$@")
    local sockets=()
    local wait_command
    local create_command

    # waiting for all the nodes to be ready..
    for node in "${nodes[@]}"; do
        read -r -a host_and_port <<< "$(to_host_and_port "$node")"
        wait_command="timeout -v 5 redis-cli -h ${host_and_port[0]} -p ${host_and_port[1]} ping"
        if is_boolean_yes "$REDIS_TLS_ENABLED"; then
            wait_command="${wait_command:0:-5} --tls --cert ${REDIS_TLS_CERT_FILE} --key ${REDIS_TLS_KEY_FILE} --cacert ${REDIS_TLS_CA_FILE} ping"
        fi
        while [[ $($wait_command) != 'PONG' ]]; do
            echo "Node $node not ready, waiting for all the nodes to be ready..."
            sleep 1
        done
    done

    echo "Waiting ${REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP}s before querying node ip addresses"
    sleep "${REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP}"

    for node in "${nodes[@]}"; do
        read -r -a host_and_port <<< "$(to_host_and_port "$node")"
        # the sockets variable just get itself's ip:port 
        sockets+=("$(wait_for_dns_lookup "${host_and_port[0]}" "${REDIS_CLUSTER_DNS_LOOKUP_RETRIES}" "${REDIS_CLUSTER_DNS_LOOKUP_SLEEP}"):${host_and_port[1]}")
    done
    # redis-cli --cluster create ip:port ip:port ip:port ip:port ip:port ip:port --cluster-replicas 1 --cluster-yes
    create_command="redis-cli --cluster create ${sockets[*]} --cluster-replicas ${REDIS_CLUSTER_REPLICAS} --cluster-yes"

    # tls set
    if is_boolean_yes "$REDIS_TLS_ENABLED"; then
        create_command="${create_command} --tls --cert ${REDIS_TLS_CERT_FILE} --key ${REDIS_TLS_KEY_FILE} --cacert ${REDIS_TLS_CA_FILE}"
    fi

    yes yes | $create_command || true
    if redis_cluster_check "${sockets[0]}"; then
        echo "Cluster correctly created"
    else
        echo "The cluster was already created, the nodes should have recovered it"
    fi
}

#########################
## Checks if the cluster state is correct.
## Params:
##  - $1: node where to check the cluster state
#########################
redis_cluster_check() {
    # tls
    if is_boolean_yes "$REDIS_TLS_ENABLED"; then
        local -r check=$(redis-cli --tls --cert "${REDIS_TLS_CERT_FILE}" --key "${REDIS_TLS_KEY_FILE}" --cacert "${REDIS_TLS_CA_FILE}" --cluster check "$1")
    else
        local -r check=$(redis-cli --cluster check "$1")
    fi
    if [[ $check =~ "All 16384 slots covered" ]]; then
        true
    else
        false
    fi
}

#########################
## Recovers the cluster when using dynamic IPs by changing them in the nodes.conf
# Globals:
#   REDIS_*
# Arguments:
#   None
# Returns:
#   None
#########################
# nodes.conf
#afe20324dfa8abef7d26d82c91c2c92532618ea9 172.20.5.83:6379@16379 slave b0280974e8050d077c854d9fa96d303c4b963d95 0 1680765520000 8 connected
#dc8d3a7e96879f196569e15a16c2fceaa1d2ed04 172.20.3.32:6379@16379 slave 8cd5108f3d01cad78bceb2586acfe122978f307b 0 1680765523000 2 connected
#8cd5108f3d01cad78bceb2586acfe122978f307b 172.20.3.40:6379@16379 master - 1680765515588 1680765508000 2 disconnected 5461-10922
#3d531dc2eb0e9ee147e0f8324945ee130f6656b3 172.20.2.49:6379@16379 myself,slave 73e656ce49c84cdd0ef7065924c3b34ad59c40cd 0 1680765517000 7 connected
#b0280974e8050d077c854d9fa96d303c4b963d95 172.20.0.58:6379@16379 master - 0 1680765523000 8 connected 10923-16383
#73e656ce49c84cdd0ef7065924c3b34ad59c40cd 172.20.1.166:6379@16379 master - 0 1680765523000 7 connected 0-5460
#vars currentEpoch 8 lastVoteEpoch 0

# nodes.sh
#declare -A host_2_ip_array=([testredis-redis-1.testredis-redis-cluster-headless]="172.20.3.31" [testredis-redis-3.testredis-redis-cluster-headless]="172.20.0.58" [testredis-redis-5.testredis-redis-cluster-headless]="172.20.3.32" [testredis-redis-0.testredis-redis-cluster-headless]="172.20.2.49" [testredis-redis-2.testredis-redis-cluster-headless]="172.20.5.83" [testredis-redis-4.testredis-redis-cluster-headless]="172.20.1.166" )
redis_cluster_update_ips() {
    read -ra nodes <<< "$(tr ',;' ' ' <<< "${REDIS_NODES}")"
    declare -A host_2_ip_array # Array to map hosts and IPs
    # Update the IPs when a number of nodes > quorum change their IPs
    if [[ ! -f "${REDIS_DATA_DIR}/nodes.sh" || ! -f "${REDIS_DATA_DIR}/nodes.conf" ]]; then
        # It is the first initialization so store the nodes
        for node in "${nodes[@]}"; do
            read -r -a host_and_port <<< "$(to_host_and_port "$node")"
            ip=$(wait_for_dns_lookup "${host_and_port[0]}" "$REDIS_DNS_RETRIES" 5)
            host_2_ip_array["$node"]="$ip"
        done
        echo "Storing map with hostnames and IPs"
        # declare -p xx host_2_ip_arry == declare -A host_2_ip_array=([redis-2]="172.24.1.238" [redis-3]="172.24.1.239" [redis-1]="172.24.1.78" )
        declare -p host_2_ip_array >"${REDIS_DATA_DIR}/nodes.sh"
    else
        # The cluster was already started
        . "${REDIS_DATA_DIR}/nodes.sh"      # it keep last cluster node information, so next need to update
        # Update the IPs in the nodes.conf
        for node in "${nodes[@]}"; do
            read -r -a host_and_port <<< "$(to_host_and_port "$node")"
            newIP=$(wait_for_dns_lookup "${host_and_port[0]}" "$REDIS_DNS_RETRIES" 5)

            # The node can be new if we are updating the cluster, so catch the unbound variable error
            # ${var+OTHER}  如果var声明了, 那么其值就是$OTHER, 否则就为null字符串
            if [[ ${host_2_ip_array[$node]+true} ]]; then
                echo "Changing old IP ${host_2_ip_array[$node]} by the new one ${newIP}"
                nodesFile=$(sed "s/ ${host_2_ip_array[$node]}:/ $newIP<NEWIP>:/g" "${REDIS_DATA_DIR}/nodes.conf")
                echo "$nodesFile" >"${REDIS_DATA_DIR}/nodes.conf"
            fi
            host_2_ip_array["$node"]="$newIP"
        done
        replace_in_file "${REDIS_DATA_DIR}/nodes.conf" "<NEWIP>:" ":" false
        declare -p host_2_ip_array >"${REDIS_DATA_DIR}/nodes.sh"
    fi
}

#########################
## Assigns a port to the host if one is not set using redis defaults
# Globals:
#   REDIS_*
# Arguments:
#   $1 - redis host or redis host and port
# Returns:
#   - 2 element Array of host and port
#########################
# REDIS_NODES=redis-node-0 redis-node-1 redis-node-2 redis-node-3 redis-node-4 redis-node-5
to_host_and_port() {
    local host="${1:?host is required}"

    # host_and_port is array
    read -r -a host_and_port <<< "$(echo "$host" | tr ":" " ")"

    if [ "${#host_and_port[*]}" -eq "1" ]; then
        if is_boolean_yes "$REDIS_TLS_ENABLED"; then
            host_and_port=("${host_and_port[0]}" "${REDIS_TLS_PORT_NUMBER}")
        else
            host_and_port=("${host_and_port[0]}" "${REDIS_PORT_NUMBER}")
        fi
    fi
    # hostname port
    echo "${host_and_port[*]}"
}
