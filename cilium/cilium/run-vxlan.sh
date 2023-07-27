helm install cilium --namespace kube-system --set \
kubeProxyReplacement=disabled,\
image.useDigest=false,\
k8sServicePort=6443,\
k8sServiceHost="192.168.0.11",\
ipam.mode="cluster-pool",\
ipam.operator.clusterPoolIPv4PodCIDRList="{172.16.0.0/16}",\
ipam.operator.clusterPoolIPv4MaskSize="24",\
tunnel=vxlan,\
tunnelPort=8472,\
ipv4.enabled=true,\
ipv6.enabled=false,\
identityAllocationMode=crd,\
cgroup.autoMount.enabled=true,\
etcd.enabled=false .
