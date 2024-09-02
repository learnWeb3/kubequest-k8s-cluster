resource "kubectl_manifest" "prometheus_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: prometheus
  YAML
}

# resource "kubectl_manifest" "prometheus_cert_manager_issuer" {
#   yaml_body = <<YAML
# apiVersion: cert-manager.io/v1
# kind: Issuer
# metadata:
#   name: prometheus
#   namespace: prometheus
# spec:
#   acme:
#     email: antoine.le-guillou@epitech.eu
#     server: https://acme-v02.api.letsencrypt.org/directory
#     privateKeySecretRef:
#       name: prometheus-issuer-account-key
#     solvers:
#       - http01:
#           ingress:
#             class: nginx
#   YAML
# }


resource "kubectl_manifest" "alertmanager_mail_secret" {
  depends_on = [kubectl_manifest.prometheus_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: mail-secrets
  namespace: prometheus
data:
  user: ${var.ALERT_MANAGER_MAIL_USERNAME}
  password: ${var.ALERT_MANAGER_MAIL_PASSWORD}
  YAML
}

resource "helm_release" "prometheus" {
  depends_on       = [kubectl_manifest.alertmanager_mail_secret]
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "61.1.1"
  namespace        = "prometheus"
  create_namespace = false
  values = [templatefile("${path.module}/prometheus-stack.values.yaml", {
    grafanaAdminPassword : var.PROMETHEUS_GRAFANA_ADMIN_PASSWORD
    mailSecret : "mail-secrets"
  })]
}


# resource "kubectl_manifest" "kubequest_ingress" {
#   depends_on = [helm_release.prometheus]
#   yaml_body  = <<YAML
# apiVersion: networking.k8s.io/v1
# kind: Ingress
# metadata:
#   name: ingress
#   namespace: prometheus
#   annotations:
#     cert-manager.io/issuer: "prometheus"
# spec:
#   ingressClassName: nginx
#   tls:
#     - hosts:
#         - metrics.students-epitech.ovh
#       secretName: tls-metrics
#   rules:
#     - host: metrics.students-epitech.ovh
#       http:
#         paths:
#           - path: /
#             pathType: Prefix
#             backend:
#               service:
#                 name: prometheus-grafana
#                 port:
#                   number: 80
#   YAML
# }

resource "helm_release" "blackbox_exporter" {
  depends_on       = [kubectl_manifest.prometheus_namespace, helm_release.prometheus]
  name             = "blackbox-exporter"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus-blackbox-exporter"
  version          = "7.6.1"
  namespace        = "prometheus"
  create_namespace = false
  values = [templatefile("${path.module}/blackbox-exporter.values.yaml", {
  })]
}

resource "kubectl_manifest" "alertmanager_config_teams_secret" {
  depends_on = [helm_release.prometheus]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: teams-webhook-secret
  namespace: prometheus
type: Opaque
stringData:
  webhookUrl: ${var.MS_TEAMS_WEBHOOK_URL}
  YAML
}

resource "kubectl_manifest" "alertmanager_config_teams" {
  depends_on = [helm_release.prometheus]
  yaml_body  = <<YAML
apiVersion: monitoring.coreos.com/v1alpha1
kind: AlertmanagerConfig
metadata:
  name: config-microsoft-teams
  namespace: prometheus
  labels:
    alertmanagerConfig: default
spec:
  route:
    groupBy: ["app", "helm.sh/chart", "app.kubernetes.io/name", "tier"]
    groupWait: 10s
    groupInterval: 10m
    repeatInterval: 1h
    receiver: microsoft-teams
  receivers:
    - name: microsoft-teams
      msteamsConfigs:
        - webhookUrl:
            key: webhookUrl
            name: teams-webhook-secret
          sendResolved: true
          title: '{{ if eq .Status "firing" }}🚨 [FIRING] 🔥{{- else -}}🙌 [RESOLVED] 🍻{{- end -}}{{ template "msteams.default.title" . }}'
          text: '{{ template "msteams.default.text" . }}'
  YAML
}


# resource "kubectl_manifest" "prometheus_rule_kubequest_application_up" {
#   depends_on = [helm_release.prometheus]
#   yaml_body  = <<YAML
# apiVersion: monitoring.coreos.com/v1
# kind: PrometheusRule
# metadata:
#   name: kubequest-application-up
#   namespace: prometheus
#   labels:
#     release: prometheus
# spec:
#   groups:
#     - name: application-status.rules
#       rules:
#         - alert: KubequestApplicationOk
#           expr: probe_success{job="blackbox-exporter-prometheus-blackbox-exporter", instance="http://kubequest.kubequest.svc.cluster.local:80"} == 1
#           for: 1m
#           labels:
#             severity: critical
#           annotations:
#             summary: "Instance {{ $labels.instance }} is ok"
#             description: "{{ $labels.instance }} of job {{ $labels.job }} is ok."
#   YAML
# }

resource "kubectl_manifest" "prometheus_rule_kubequest_application_down" {
  depends_on = [helm_release.prometheus]
  yaml_body  = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: kubequest-application-down
  namespace: prometheus
  labels:
    release: prometheus
spec:
  groups:
    - name: application-status.rules
      rules:
        - alert: KubequestApplicationUnreachable
          expr: probe_success{job="blackbox-exporter-prometheus-blackbox-exporter", instance="http://kubequest.kubequest.svc.cluster.local:80"} == 0
          for: 1m
          labels:
            severity: critical
          annotations:
            summary: "Instance {{ $labels.instance }} unreachable"
            description: "{{ $labels.instance }} of job {{ $labels.job }} has been unreachable for more than 1 minutes."
  YAML
}

resource "kubectl_manifest" "prometheus_rule_kubequest_application_replicas_increase" {
  depends_on = [helm_release.prometheus]
  yaml_body  = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: kubequest-application-replicas-increase
  namespace: prometheus
  labels:
    release: prometheus
spec:
  groups:
    - name: kubequest.rules
      rules:
        - alert: KubequestApplicationReplicasIncrease
          expr: |
            sum by(deployment) (kube_deployment_spec_replicas{deployment="kubequest", namespace="kubequest"}) 
            > 
            sum by(deployment) (kube_deployment_status_replicas{deployment="kubequest", namespace="kubequest"})
          labels:
            severity: warning
          annotations:
            summary: "The replica count of kubequest deployment has increased"
            description: "The replica count of kubequest deployment has increased from {{ $value }} replicas."
  YAML
}

resource "kubectl_manifest" "prometheus_rule_mysql_down" {
  depends_on = [helm_release.prometheus]
  yaml_body  = <<YAML
apiVersion: monitoring.coreos.com/v1
kind: PrometheusRule
metadata:
  name: mysql-down
  namespace: prometheus
  labels:
    release: prometheus
spec:
  groups:
    - name: mysql.rules
      rules:
        - alert: MySQLDown
          expr: mysql_up == 0
          for: 1m
          labels:
            severity: critical
          annotations:
            summary: "MySQL instance is down"
            description: "The MySQL instance '{{ $labels.instance }}' is down for more than 5 minutes."
  YAML
}
