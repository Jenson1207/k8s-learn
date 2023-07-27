helm install redis-cluster -n test --atomic --create-namespace --set \
usePassword=true,\
password=redis,\
tls.enabled=false,\
service.type=NodePort,\
persistence.storageClass=nfs-client,\
persistence.enabled=true,\
redis.useAOFPersistence=yes,\
cluster.init=true,\
cluster.nodes=6,\
cluster.replicas=1,\
metrics.enabled=false .