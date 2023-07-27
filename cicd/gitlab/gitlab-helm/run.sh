helm install gitlab -n devops \
--set global.edition=ce \
--set global.hosts.domain=192.168.0.11 \
--set global.hosts.externalIP=192.168.0.11 \
--set global.image.pullPolicy=IfNotPresent \
--set global.minio.enabled=false \
--set global.time_zone=Asia/Shanghai \
--set certmanager-issuer.email=false \
--set global.hosts.https=true \
--set global.ingress.configureCertmanager=false \
--set certmanager.rbac.create=false \
--set nginx-ingress.enabled=false \
--set nginx-ingress.rbac.create=false \
--set nginx-ingress.rbac.createClusterRole=false \
--set nginx-ingress.rbac.createRole=false \
--set prometheus.install=false \
--set prometheus.rbac.create=false \
--set gitlab-runner.rbac.create=true \
--set gitlab-runner.checkInterval=30s \
--set gitlab-runner.concurrent=20 \
--set gitlab-runner.imagePullPolicy=IfNotPresent \
--set gitlab-runner.image=gitlab/gitlab-runner:alpine-v10.5.0 \
--set gitlab-runner.install=false \
--set redis.install=true \
--set postgresql.install=true \