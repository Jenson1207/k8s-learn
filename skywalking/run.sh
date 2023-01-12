helm install "skywalking" -n skywalking \
--set elasticsearch.replicas=1 \
--set elasticsearch.minimumMasterNodes=1 \
--set oap.image.tag=9.1.0 \
--set oap.storageType=elasticsearch \
--set ui.image.tag=9.1.0 \
--set elasticsearch.imageTag=7.5.1 .
