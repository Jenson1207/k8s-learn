#!/bin/bash
#helm install harbor -n harbor --set externalURL=https://192.168.0.10:30008,\
#harborAdminPassword=Harbor12345,\
#expose.type=nodePort,\
#nginx.nodeSelector.harbor=yes,\
#portal.nodeSelector.harbor=yes,\
#core.nodeSelector.harbor=yes,\
#jobservice.nodeSelector.harbor=yes,\
#registry.nodeSelector.harbor=yes,\
#chartmuseum.nodeSelector.harbor=yes,\
#notary.nodeSelector.harbor=yes,\
#database.internal.nodeSelector.harbor=yes,\
#redis.internal.nodeSelector.harbor=yes,\
#exporter.nodeSelector.harbor=yes,\
#trivy.nodeSelector.harbor=yes,\
#persistence.enabled=false,\
#expose.tls.enabled=yes,expose.tls.auto.commonName=192.168.0.10,\
#expose.nodePort.ports.https.nodePort=30008 .

helm install harbor -n harbor --set externalURL=https://192.168.0.10:30008,\
harborAdminPassword=Harbor12345,\
expose.type=nodePort,\
persistence.enabled=false,\
expose.tls.certSource=secret,\
expose.tls.secret.secretName=harbor-nginx,\
expose.nodePort.ports.https.nodePort=30008,\
internalTLS.enabled=false .
