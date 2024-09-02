
resource "kubectl_manifest" "kubequest_configmap" {
  depends_on = [kubectl_manifest.kubequest_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: kubequest
  namespace: kubequest
data:
  APP_DEBUG: "false"
  APP_ENV: "production"
  DB_CONNECTION: mysql
  DB_HOST: mysql-cluster-mysql.mysql-operator.svc.cluster.local
  DB_PORT: "3306"
  DB_DATABASE: kubequest
  YAML
}

resource "kubectl_manifest" "kubequest_secret" {
  depends_on = [kubectl_manifest.kubequest_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: kubequest
  namespace: kubequest
data:
  # MYSQL
  APP_KEY: ${var.APP_KEY}
  DB_PASSWORD: ${var.DB_PASSWORD}
  DB_USERNAME: ${var.DB_USERNAME}
  YAML
}

resource "kubectl_manifest" "kubequest_service" {
  depends_on = [kubectl_manifest.kubequest_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: kubequest
  namespace: kubequest
spec:
  selector:
    tier: kubequest
  type: ClusterIP
  ports:
    - port: 80
      targetPort: 80
      name: public
  YAML
}

resource "kubectl_manifest" "kubequest_ingress" {
  depends_on = [kubectl_manifest.kubequest_cert_manager_issuer]
  yaml_body  = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: kubequest-ingress
  namespace: kubequest
  annotations:
    cert-manager.io/issuer: kubequest
spec:
  ingressClassName: nginx
  tls:
    - hosts:
        - kubequest.students-epitech.ovh
      secretName: tls-kubequest
  rules:
    - host: kubequest.students-epitech.ovh
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: kubequest
                port:
                  number: 80
  YAML
}

resource "kubectl_manifest" "kubequest_deployment" {
  depends_on = [kubectl_manifest.kubequest_secret, kubectl_manifest.kubequest_configmap]
  yaml_body  = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kubequest
  namespace: kubequest
  labels:
    tier: kubequest
spec:
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  replicas: 1
  selector:
    matchLabels:
      tier: kubequest
  template:
    metadata:
      labels:
        tier: kubequest
    spec:
      initContainers:
        - name: init
          image: antoineleguillou/kubequest:2024-06-28.1
          imagePullPolicy: IfNotPresent
          command: ["/bin/bash", "-c"]
          envFrom:
            - configMapRef:
                name: kubequest
            - secretRef:
                name: kubequest
          args:
            - |
              php artisan migrate --force
      containers:
        - name: kubequest
          image: antoineleguillou/kubequest:2024-07-12.24
          imagePullPolicy: IfNotPresent
          resources:
            limits:
              cpu: 350m
              memory: 450Mi
            requests:
              cpu: 250m
              memory: 250Mi
          envFrom:
            - configMapRef:
                name: kubequest
            - secretRef:
                name: kubequest
          ports:
            - containerPort: 80
      restartPolicy: Always
  YAML
}

resource "kubectl_manifest" "kubequest_hpa" {
  depends_on = [kubectl_manifest.kubequest_deployment]
  yaml_body  = <<YAML
apiVersion: autoscaling/v2
kind: HorizontalPodAutoscaler
metadata:
  name: kubequest
  namespace: kubequest
spec:
  maxReplicas: 6
  metrics:
  - resource:
      name: cpu
      target:
        averageUtilization: 75
        type: Utilization
    type: Resource
  minReplicas: 1
  scaleTargetRef:
    apiVersion: apps/v1
    kind: Deployment
    name: kubequest
  YAML
}

resource "helm_release" "autoscaling_tester_operator" {
  depends_on       = [kubectl_manifest.kubequest_namespace]
  name             = "autoscaling-tester-operator"
  repository       = "https://learnweb3.github.io/autoscaling-tester-operator/"
  chart            = "autoscaling-tester-operator"
  version          = "0.1.0"
  namespace        = "kubequest"
  create_namespace = false
}

resource "kubectl_manifest" "kubequest_autoscaling_test_job" {
  depends_on = [helm_release.autoscaling_tester_operator]
  yaml_body  = <<YAML
apiVersion: cache.students-epitech.ovh/v1alpha1
kind: AutoscalingTestJob
metadata:
  name: kubequest
  namespace: kubequest
spec:
  job:
    durationMs: 300000
    replicas: 15
    image: antoineleguillou/alpine-curl:2024-07-12.1
    command: ["sh", "-c"]
    progressDeadlineSeconds: 10
    args:
      - while true; do curl --fail -X GET 'http://kubequest.kubequest.svc.cluster.local:80'; sleep 2; done;
    resources:
      requests:
        cpu: 50m
        memory: 50Mi
      limits:
        cpu: 100m
        memory: 100Mi
  YAML
}





