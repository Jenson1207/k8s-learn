

| Name                                    | Description                                                  |
| --------------------------------------- | ------------------------------------------------------------ |
| `REDIS_DISABLE_COMMANDS`                | Disables the specified Redis(R) commands                     |
| `REDIS_PORT_NUMBER`                     | Set the Redis(R) port. Default=: `6379`                      |
| `REDIS_PASSWORD`                        | Set the Redis(R) password. Default: `bitnami`                |
| `ALLOW_EMPTY_PASSWORD`                  | Enables access without password                              |
| `REDIS_DNS_RETRIES`                     | Number of retries to get the IPs of the provided `REDIS_NODES`. It will wait 5 seconds between retries |
| `REDISCLI_AUTH`                         | Provide the same value as the configured `REDIS_PASSWORD` for the redis-cli tool to authenticate |
| `REDIS_CLUSTER_CREATOR`                 | Set to `yes` if the container will be the one on charge of initialize the cluster. This node will also be part of the cluster. |
| `REDIS_CLUSTER_REPLICAS`                | Number of replicas for every master that the cluster will have. |
| `REDIS_NODES`                           | String delimited by spaces containing the hostnames of all of the nodes that will be part of the cluster |
| `REDIS_CLUSTER_ANNOUNCE_IP`             | IP that the node should announce, used for non dynamic ip environments |
| `REDIS_CLUSTER_ANNOUNCE_PORT`           | Port that the node should announce, used for non dynamic ip environments. |
| `REDIS_CLUSTER_ANNOUNCE_HOSTNAME`       | Hostname that node should announce, used for non dynamic ip environments. |
| `REDIS_CLUSTER_PREFERRED_ENDPOINT_TYPE` | Preferred endpoint type which cluster should use, options- ip, hostname |
| `REDIS_CLUSTER_ANNOUNCE_BUS_PORT`       | The cluster bus port to announce.                            |
| `REDIS_CLUSTER_DYNAMIC_IPS`             | Set to `no` if your Redis(R) cluster will be created with statical IPs. Default: `yes` |
| `REDIS_TLS_ENABLED`                     | Whether to enable TLS for traffic or not. Defaults to `no`.  |
| `REDIS_TLS_PORT_NUMBER`                 | Port used for TLS secure traffic. Defaults to `6379`.        |
| `REDIS_TLS_CERT_FILE`                   | File containing the certificate file for the TLS traffic. No defaults. |
| `REDIS_TLS_KEY_FILE`                    | File containing the key for certificate. No defaults.        |
| `REDIS_TLS_CA_FILE`                     | File containing the CA of the certificate. No defaults.      |
| `REDIS_TLS_DH_PARAMS_FILE`              | File containing DH params (in order to support DH based ciphers). No defaults. |
| `REDIS_TLS_AUTH_CLIENTS`                | Whether to require clients to authenticate or not. Defaults to `yes`. |
| `REDIS_CLUSTER_SLEEP_BEFORE_DNS_LOOKUP` | Number of seconds to wait before initializing the cluster. Set this to a higher value if you sometimes have issues with initial cluster creation. Defaults to `0`. |
| `REDIS_CLUSTER_DNS_LOOKUP_RETRIES`      | Number of retries for the node's DNS lookup during the initial cluster creation. Defaults to `5`. |
| `REDIS_CLUSTER_DNS_LOOKUP_SLEEP`        | Number of seconds to wait between each node's DNS lookup during the initial cluster creation. Defaults to `1`. |
| `REDIS_IO_THREADS`                      | Number of threads to implement multithreading operations. Defaults to `1`. |
| `REDIS_IO_THREADS_DO_READS`             | Enables multithreading for read operations. Defaults to `false`. |
| `REDIS_RDB_POLICY`                      | Set this variable to enable RDB persistent storage RDB data synchronization strategy configuration example `900#1 300#10 60#1000` Defaults to disable RDB persistent storage. |