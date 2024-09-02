resource "kubectl_manifest" "lokki_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: lokki
  YAML
}

resource "kubectl_manifest" "grafana_alloy_configmap" {
  depends_on = [kubectl_manifest.lokki_namespace, helm_release.prometheus]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: grafana-alloy-config
  namespace: lokki
data:
  config.alloy: |
    loki.write "default" {
      endpoint {
        url = "http://loki-gateway.lokki.svc.cluster.local/loki/api/v1/push"
        tenant_id = "kubequest"
      }
    }


    // discovery.kubernetes allows you to find scrape targets from Kubernetes resources.
    // It watches cluster state and ensures targets are continually synced with what is currently running in your cluster.
    discovery.kubernetes "pod" {
      role = "pod"
      namespaces {
        names =  ["kubequest", "mysql", "prometheus", "loki"]
      }
    }

    // discovery.relabel rewrites the label set of the input targets by applying one or more relabeling rules.
    // If no rules are defined, then the input targets are exported as-is.
    discovery.relabel "pod_logs" {
      targets = discovery.kubernetes.pod.targets

      // Label creation - "namespace" field from "__meta_kubernetes_namespace"
      rule {
        source_labels = ["__meta_kubernetes_namespace"]
        action = "replace"
        target_label = "namespace"
      }

      // Label creation - "pod" field from "__meta_kubernetes_pod_name"
      rule {
        source_labels = ["__meta_kubernetes_pod_name"]
        action = "replace"
        target_label = "pod"
      }

      // Label creation - "container" field from "__meta_kubernetes_pod_container_name"
      rule {
        source_labels = ["__meta_kubernetes_pod_container_name"]
        action = "replace"
        target_label = "container"
      }

      // Label creation -  "app" field from "__meta_kubernetes_pod_label_app_kubernetes_io_name"
      rule {
        source_labels = ["__meta_kubernetes_pod_label_app_kubernetes_io_name"]
        action = "replace"
        target_label = "app"
      }

      // Label creation -  "job" field from "__meta_kubernetes_namespace" and "__meta_kubernetes_pod_container_name"
      // Concatenate values __meta_kubernetes_namespace/__meta_kubernetes_pod_container_name
      rule {
        source_labels = ["__meta_kubernetes_namespace", "__meta_kubernetes_pod_container_name"]
        action = "replace"
        target_label = "job"
        separator = "/"
        replacement = "$1"
      }

      // Label creation - "container" field from "__meta_kubernetes_pod_uid" and "__meta_kubernetes_pod_container_name"
      // Concatenate values __meta_kubernetes_pod_uid/__meta_kubernetes_pod_container_name.log
      rule {
        source_labels = ["__meta_kubernetes_pod_uid", "__meta_kubernetes_pod_container_name"]
        action = "replace"
        target_label = "__path__"
        separator = "/"
        replacement = "/var/log/pods/*$1/*.log"
      }

      // Label creation -  "container_runtime" field from "__meta_kubernetes_pod_container_id"
      rule {
        source_labels = ["__meta_kubernetes_pod_container_id"]
        action = "replace"
        target_label = "container_runtime"
        regex = "^(\\S+):\\/\\/.+$"
        replacement = "$1"
      }
    }

    // loki.source.kubernetes tails logs from Kubernetes containers using the Kubernetes API.
    loki.source.kubernetes "pod_logs" {
      targets    = discovery.relabel.pod_logs.output
      forward_to = [loki.process.pod_logs.receiver]
    }

    // loki.process receives log entries from other Loki components, applies one or more processing stages,
    // and forwards the results to the list of receivers in the component’s arguments.
    loki.process "pod_logs" {
      stage.static_labels {
          values = {
            cluster = "kubequest",
          }
      }

      forward_to = [loki.write.default.receiver]
    }

  YAML
}

resource "helm_release" "lokki" {
  depends_on       = [kubectl_manifest.lokki_namespace, helm_release.prometheus]
  name             = "loki"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "loki"
  version          = "6.6.4"
  namespace        = "lokki"
  create_namespace = false
  values = [templatefile("${path.module}/lokki.values.yaml", {
  })]
}

resource "helm_release" "grafana_alloy" {
  depends_on       = [kubectl_manifest.grafana_alloy_configmap, helm_release.prometheus]
  name             = "grafana-alloy"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "alloy"
  version          = "0.4.0"
  namespace        = "lokki"
  create_namespace = false
  values = [templatefile("${path.module}/grafana-alloy.values.yaml", {
  })]
}
