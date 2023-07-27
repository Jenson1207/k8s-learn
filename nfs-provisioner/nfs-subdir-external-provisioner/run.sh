helm install nfs-provisioner -n default --atomic --create-namespace --set \
replicaCount=1,\
image.repository=docker.io/dyrnq/nfs-subdir-external-provisioner,\
image.tag=v4.0.2,\
storageClass.name=nfs-client,\
storageClass.reclaimPolicy=Delete,\
nfs.server=192.168.0.11,\
nodeSelector."kubernetes\\.io/hostname"=k8s-master-1,\
nfs.path=/data/nfs-client .
