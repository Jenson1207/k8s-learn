#!/bin/bash
helm install monitor -n monitor --set \
alertmanager.image.repository=quay.io/prometheus/alertmanager,\
alertmanager.image.tag=v0.24.0,\
prometheusOperator.admissionWebhooks.patch.image.repository=registry.cn-hangzhou.aliyuncs.com/google_containers/kube-webhook-certgen,\
prometheusOperator.admissionWebhooks.patch.tag=v1.2.0,\
prometheusOperator.image.repository=quay.io/prometheus-operator/prometheus-operator,\
prometheusOperator.image.tag=v0.58.0,\
prometheusOperator.prometheusConfigReloader.image.repository=quay.io/prometheus-operator/prometheus-config-reloader,\
prometheusOperator.prometheusConfigReloader.image.tag=v0.58.0,\
prometheusOperator.thanosImage.repository=quay.io/thanos/thanos,\
prometheusOperator.thanosImage.tag=v0.27.0,\
prometheus.image.repository=quay.io/prometheus/prometheus,\
prometheus.image.tag=v2.37.0,\
kube-state-metrics.image.repository=bitnami/kube-state-metrics,\
kube-state-metrics.image.tag=2.5.0,\
prometheus.service.type=NodePort,\
prometheus.service.nodePort=30003,\
alertmanager.service.type=NodePort,\
alertmanager.service.nodePort=30004,\
grafana.service.type=NodePort,\
grafana.service.nodePort=30005 .
