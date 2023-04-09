#!/bin/bash
function install(){
helm install monitor -n monitor --atomic --force --create-namespace --set \
prometheusOperator.admissionWebhooks.patch.image.registry=docker.io,\
prometheusOperator.admissionWebhooks.patch.image.repository=jiayu98/kube-webhook-certgen,\
prometheusOperator.admissionWebhooks.patch.tag=v1.3.0,\
prometheusOperator.image.registry=docker.io,\
prometheusOperator.image.repository=jiayu98/prometheus-operator,\
prometheusOperator.image.tag=v0.63.0,\
prometheusOperator.prometheusConfigReloader.image.registry=docker.io,\
prometheusOperator.prometheusConfigReloader.image.repository=jiayu98/prometheus-config-reloader,\
prometheusOperator.prometheusConfigReloader.image.tag=v0.63.0,\
prometheusOperator.thanosImage.registry=docker.io,\
prometheusOperator.thanosImage.repository=jiayu98/thanos,\
prometheusOperator.thanosImage.tag=v0.30.2,\
prometheus.prometheusSpec.image.registry=docker.io,\
prometheus.prometheusSpec.image.repository=jiayu98/prometheus,\
prometheus.prometheusSpec.image.tag=v2.42.0,\
alertmanager.alertmanagerSpec.image.registry=docker.io,\
alertmanager.alertmanagerSpec.image.repository=jiayu98/alertmanager,\
alertmanager.alertmanagerSpec.image.tag=v0.25.0,\
prometheus-node-exporter.image.registry=docker.io/jiayu98/node-exporter,\
prometheus-node-exporter.image.tag=v1.5.0,\
kube-state-metrics.image.repository=docker.io/jiayu98/kube-state-metrics,\
kube-state-metrics.image.tag=v2.8.0,\
grafana.image.repository=docker.io/jiayu98/grafana,\
grafana.image.tag=9.3.6,\
grafana.testFramework.enabled=false,\
grafana.sidecar.image.repository=docker.io/jiayu98/k8s-sidecar,\
grafana.sidecar.image.tag=1.22.0,\
prometheus.service.type=NodePort,\
prometheus.service.nodePort=30003,\
alertmanager.service.type=NodePort,\
alertmanager.service.nodePort=30004,\
grafana.service.type=NodePort,\
grafana.service.nodePort=30005,\
defaultRules.create=true .
}

function uninstall(){
	helm uninstall monitor -n monitor
}

function template(){
helm template monitor -n monitor --set \
prometheusOperator.admissionWebhooks.patch.image.registry=docker.io,\
prometheusOperator.admissionWebhooks.patch.image.repository=jiayu98/kube-webhook-certgen,\
prometheusOperator.admissionWebhooks.patch.tag=v1.3.0,\
prometheusOperator.image.registry=docker.io,\
prometheusOperator.image.repository=jiayu98/prometheus-operator,\
prometheusOperator.image.tag=v0.63.0,\
prometheusOperator.prometheusConfigReloader.image.registry=docker.io,\
prometheusOperator.prometheusConfigReloader.image.repository=jiayu98/prometheus-config-reloader,\
prometheusOperator.prometheusConfigReloader.image.tag=v0.63.0,\
prometheusOperator.thanosImage.registry=docker.io,\
prometheusOperator.thanosImage.repository=jiayu98/thanos,\
prometheusOperator.thanosImage.tag=v0.30.2,\
prometheus.prometheusSpec.image.registry=docker.io,\
prometheus.prometheusSpec.image.repository=jiayu98/prometheus,\
prometheus.prometheusSpec.image.tag=v2.42.0,\
alertmanager.alertmanagerSpec.image.registry=docker.io,\
alertmanager.alertmanagerSpec.image.repository=jiayu98/alertmanager,\
alertmanager.alertmanagerSpec.image.tag=v0.25.0,\
prometheus-node-exporter.image.registry=docker.io/jiayu98/node-exporter,\
prometheus-node-exporter.image.tag=v1.5.0,\
kube-state-metrics.image.repository=docker.io/jiayu98/kube-state-metrics,\
kube-state-metrics.image.tag=v2.8.0,\
grafana.image.repository=docker.io/jiayu98/grafana,\
grafana.image.tag=9.3.6,\
grafana.testFramework.enabled=false,\
grafana.sidecar.image.repository=docker.io/jiayu98/k8s-sidecar,\
grafana.sidecar.image.tag=1.22.0,\
prometheus.service.type=NodePort,\
prometheus.service.nodePort=30003,\
alertmanager.service.type=NodePort,\
alertmanager.service.nodePort=30004,\
grafana.service.type=NodePort,\
grafana.service.nodePort=30005,\
defaultRules.create=true .
}

case $1 in
"install")
	install
;;
"uninstall")
	uninstall
;;
"template")
	template
;;
esac
