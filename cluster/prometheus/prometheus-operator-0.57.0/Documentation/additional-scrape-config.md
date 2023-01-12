# Additional Scrape Configuration

AdditionalScrapeConfigs allows specifying a key of a Secret containing
additional Prometheus scrape configurations. Scrape configurations specified
are appended to the configurations generated by the Prometheus Operator.

Job configurations specified must have the form as specified in the official
[Prometheus documentation](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#scrape_config).
As scrape configs are appended, the user is responsible to make sure it is
valid. *Note* that using this feature may expose the possibility to break
upgrades of Prometheus.

It is advised to review Prometheus release notes to ensure that no incompatible
scrape configs are going to break Prometheus after the upgrade.

## Creating an additional configuration

First, you will need to create the additional configuration.
Below we are making a simple "prometheus" config. Name this
`prometheus-additional.yaml` or something similar.

```yaml
- job_name: "prometheus"
  static_configs:
  - targets: ["localhost:9090"]
```

Then you will need to make a secret out of this configuration.

```sh
kubectl create secret generic additional-scrape-configs --from-file=prometheus-additional.yaml --dry-run -oyaml > additional-scrape-configs.yaml
```

Next, apply the generated kubernetes manifest

```
kubectl apply -f additional-scrape-configs.yaml -n monitoring
```

Finally, reference this additional configuration in your `prometheus.yaml` CRD.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
  labels:
    prometheus: prometheus
spec:
  replicas: 2
  serviceAccountName: prometheus
  serviceMonitorSelector:
    matchLabels:
      team: frontend
  additionalScrapeConfigs:
    name: additional-scrape-configs
    key: prometheus-additional.yaml
```

NOTE: Use only one secret for ALL additional scrape configurations.

## Additional References

* [Prometheus Spec](api.md#prometheusspec)
* [Additional Scrape Configs](../example/additional-scrape-configs)