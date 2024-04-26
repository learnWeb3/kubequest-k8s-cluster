resource "kubectl_manifest" "andrew_staging_namespace" {
  yaml_body = <<YAML
apiVersion: v1
kind: Namespace
metadata: 
  name: andrew-staging
  YAML
}

resource "kubectl_manifest" "andrew_staging_cert_manager_issuer" {
  yaml_body = <<YAML
apiVersion: cert-manager.io/v1
kind: Issuer
metadata:
  name: cert-manager-andrew-staging-issuer
  namespace: andrew-staging
spec:
  acme:
    email: antoine.le-guillou@epitech.eu
    server: https://acme-v02.api.letsencrypt.org/directory
    privateKeySecretRef:
      name: cert-manager-andrew-staging-issuer-account-key
    solvers:
      - http01:
          ingress:
            class: nginx
    caBundle: |
      LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUZhekNDQTFPZ0F3SUJBZ0lS
      QUlJUXo3RFNRT05aUkdQZ3UyT0Npd0F3RFFZSktvWklodmNOQVFFTEJRQXcKVHpF
      TE1Ba0dBMVVFQmhNQ1ZWTXhLVEFuQmdOVkJBb1RJRWx1ZEdWeWJtVjBJRk5sWTNW
      eWFYUjVJRkpsYzJWaApjbU5vSUVkeWIzVndNUlV3RXdZRFZRUURFd3hKVTFKSElG
      SnZiM1FnV0RFd0hoY05NVFV3TmpBME1URXdORE00CldoY05NelV3TmpBME1URXdO
      RE00V2pCUE1Rc3dDUVlEVlFRR0V3SlZVekVwTUNjR0ExVUVDaE1nU1c1MFpYSnUK
      WlhRZ1UyVmpkWEpwZEhrZ1VtVnpaV0Z5WTJnZ1IzSnZkWEF4RlRBVEJnTlZCQU1U
      REVsVFVrY2dVbTl2ZENCWQpNVENDQWlJd0RRWUpLb1pJaHZjTkFRRUJCUUFEZ2dJ
      UEFEQ0NBZ29DZ2dJQkFLM29KSFAwRkRmem01NHJWeWdjCmg3N2N0OTg0a0l4dVBP
      WlhvSGozZGNLaS92VnFidllBVHlqYjNtaUdiRVNUdHJGai9SUVNhNzhmMHVveG15
      RisKMFRNOHVrajEzWG5mczdqL0V2RWhta3ZCaW9aeGFVcG1abXlQZmp4d3Y2MHBJ
      Z2J6NU1EbWdLN2lTNCszbVg2VQpBNS9UUjVkOG1VZ2pVK2c0cms4S2I0TXUwVWxY
      aklCMHR0b3YwRGlOZXdOd0lSdDE4akE4K28rdTNkcGpxK3NXClQ4S09FVXQrend2
      by83VjNMdlN5ZTByZ1RCSWxESENOQXltZzRWTWs3QlBaN2htL0VMTktqRCtKbzJG
      UjNxeUgKQjVUMFkzSHNMdUp2VzVpQjRZbGNOSGxzZHU4N2tHSjU1dHVrbWk4bXhk
      QVE0UTdlMlJDT0Z2dTM5NmozeCtVQwpCNWlQTmdpVjUrSTNsZzAyZFo3N0RuS3hI
      WnU4QS9sSkJkaUIzUVcwS3RaQjZhd0JkcFVLRDlqZjFiMFNIelV2CktCZHMwcGpC
      cUFsa2QyNUhON3JPckZsZWFKMS9jdGFKeFFaQktUNVpQdDBtOVNUSkVhZGFvMHhB
      SDBhaG1iV24KT2xGdWhqdWVmWEtuRWdWNFdlMCtVWGdWQ3dPUGpkQXZCYkkrZTBv
      Y1MzTUZFdnpHNnVCUUUzeERrM1N6eW5UbgpqaDhCQ05BdzFGdHhOclFIdXNFd01G
      eEl0NEk3bUtaOVlJcWlveW1DekxxOWd3UWJvb01EUWFIV0JmRWJ3cmJ3CnFIeUdP
      MGFvU0NxSTNIYWFkcjhmYXFVOUdZL3JPUE5rM3NnckRRb28vL2ZiNGhWQzFDTFFK
      MTNoZWY0WTUzQ0kKclU3bTJZczZ4dDBuVVc3L3ZHVDFNME5QQWdNQkFBR2pRakJB
      TUE0R0ExVWREd0VCL3dRRUF3SUJCakFQQmdOVgpIUk1CQWY4RUJUQURBUUgvTUIw
      R0ExVWREZ1FXQkJSNXRGbm1lN2JsNUFGemdBaUl5QnBZOXVtYmJqQU5CZ2txCmhr
      aUc5dzBCQVFzRkFBT0NBZ0VBVlI5WXFieXlxRkRRRExIWUdta2dKeWtJckdGMVhJ
      cHUrSUxsYVMvVjlsWkwKdWJoekVGblRJWmQrNTB4eCs3TFNZSzA1cUF2cUZ5Rldo
      ZkZRRGxucnp1Qlo2YnJKRmUrR25ZK0VnUGJrNlpHUQozQmViWWh0RjhHYVYwbnh2
      d3VvNzd4L1B5OWF1Si9HcHNNaXUvWDErbXZvaUJPdi8yWC9xa1NzaXNSY09qL0tL
      Ck5GdFkyUHdCeVZTNXVDYk1pb2d6aVV3dGhEeUMzKzZXVndXNkxMdjN4TGZIVGp1
      Q3ZqSElJbk56a3RIQ2dLUTUKT1JBekk0Sk1QSitHc2xXWUhiNHBob3dpbTU3aWF6
      dFhPb0p3VGR3Sng0bkxDZ2ROYk9oZGpzbnZ6cXZIdTdVcgpUa1hXU3RBbXpPVnl5
      Z2hxcFpYakZhSDNwTzNKTEYrbCsvK3NLQUl1dnRkN3UrTnhlNUFXMHdkZVJsTjhO
      d2RDCmpOUEVscHpWbWJVcTRKVWFnRWl1VERrSHpzeEhwRktWSzdxNCs2M1NNMU45
      NVIxTmJkV2hzY2RDYitaQUp6VmMKb3lpM0I0M25qVE9RNXlPZisxQ2NlV3hHMWJR
      VnM1WnVmcHNNbGpxNFVpMC8xbHZoK3dqQ2hQNGtxS09KMnF4cQo0Umdxc2FoRFlW
      dlRIOXc3alhieUxlaU5kZDhYTTJ3OVUvdDd5MEZmLzl5aTBHRTQ0WmE0ckYyTE45
      ZDExVFBBCm1SR3VuVUhCY25XRXZnSkJRbDluSkVpVTBac252Z2MvdWJoUGdYUlI0
      WHEzN1owajRyN2cxU2dFRXp3eEE1N2QKZW15UHhnY1l4bi9lUjQ0L0tKNEVCcyts
      VkRSM3ZleUptK2tYUTk5YjIxLytqaDVYb3MxQW5YNWlJdHJlR0NjPQotLS0tLUVO
      RCBDRVJUSUZJQ0FURS0tLS0tCg==
  YAML
}

resource "kubectl_manifest" "andrew_staging_api_configmap" {
  depends_on = [kubectl_manifest.andrew_staging_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: ConfigMap
metadata:
  name: andrew-api-configmap
data:
  KEYCLOAK_ADMIN_CLIENT_ID: "andrew-api"
  KEYCLOAK_OPENID_CONNECT_AUTHORITY: https://login.students-epitech.ovh/realms/andrew
  KEYCLOAK_CERTS_URL: "https://login.students-epitech.ovh/realms/andrew/protocol/openid-connect/certs"
  KEYCLOAK_ISSUER: "https://login.students-epitech.ovh/realms/andrew"
  KEYCLOAK_AUDIENCE: "andrew-app"
  KEYCLOAK_ACCESS_TOKEN_ROLES_KEY: "roles"
  KEYCLOAK_BASE_URL: "http://keycloak.auth-staging.svc.cluster.local:80"
  KEYCLOAK_REALM_NAME: "andrew"
  KEYCLOAK_DEVICE_ROLE_NAME: "device"
  GOOGLE_STORAGE_PROJECT_ID: "sinuous-athlete-403218"
  GOOGLE_STORAGE_CLIENT_EMAIL: "andrew-storage@sinuous-athlete-403218.iam.gserviceaccount.com"
  GOOGLE_STORAGE_BUCKET_NAME: "andrew-documents"
  OPENSEARCH_ACL_INDEX: "acl"
  OPENSEARCH_ACL_REPORT_INDEX: "acl_report"
  KAFKA_CLIENT_ID: "api"
  WEBSOCKET_PORT: "8888"
  NODE_TLS_REJECT_UNAUTHORIZED: "0"
  KAFKA_BROKERS: kafka-cluster-kafka-0.kafka-cluster-kafka-brokers.kafka-operator-system.svc.cluster.local:9092
  KAFKAJS_NO_PARTITIONER_WARNING: "1"
  KAFKA_TOPIC: "andrew-device-metrics"
  KAFKA_SASL_USERNAME: "andrew-device-metrics-consumer"
  KAFKA_GROUP_ID_PREFIX: "andrew-device-consumer-metrics"
  KAFKA_ECOMMERCE_TOPIC: "andrew-ecommerce"
  KAFKA_ECOMMERCE_SASL_USERNAME: "andrew-ecommerce-consumer"
  KAFKA_ECOMMERCE_GROUP_ID_PREFIX: "andrew-ecommerce"
  MQTT_BROKER_HOST: "andrew-mqtt-oauth-broker.students-epitech.ovh"
  MQTT_AUTH_USERNAME: "api"
  MQTT_BROKER_PROTOCOL: "wss"
  ECOMMERCE_SERVICE_PUBLIC_LISTENER_ROOT_URL: http://andrew-ecommerce-service.andrew-staging.svc.cluster.local:3000/api
  ECOMMERCE_SERVICE_PRIVATE_LISTENER_ROOT_URL: http://andrew-ecommerce-service.andrew-staging.svc.cluster.local:3001/api
  BASIC_AUTH_PASSWORD: "1lO4Ko3pbZI1"
  NODE_ENV: "production"
  YAML
}

resource "kubectl_manifest" "andrew_staging_api_secret" {
  depends_on = [kubectl_manifest.andrew_staging_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
type: Opaque
metadata:
  name: andrew-api-secrets
data:
  # MQTT
  MQTT_AUTH_PASSWORD: ${ var.MQTT_AUTH_PASSWORD }
  # KAFKA
  KAFKA_SASL_PASSWORD: ${ var.KAFKA_SASL_PASSWORD }
  # KAFKA ECOMMERCE
  KAFKA_ECOMMERCE_SASL_PASSWORD: ${ var.KAFKA_ECOMMERCE_SASL_PASSWORD }
  # GOOGLE STORAGE
  GOOGLE_STORAGE_PRIVATE_KEY: ${ var.GOOGLE_STORAGE_PRIVATE_KEY }
  # KEYCLOAK
  KEYCLOAK_ADMIN_CLIENT_SECRET: ${ var.KEYCLOAK_ADMIN_CLIENT_SECRET }
  # OPENSEARCH
  OPENSEARCH_URL: ${ var.OPENSEARCH_URL}
  # MONGO
  MONGO_URI: ${ var.MONGO_URI }
  YAML
}


resource "kubectl_manifest" "andrew_staging_api_service" {
  depends_on = [kubectl_manifest.andrew_staging_namespace]
  yaml_body  = <<YAML
apiVersion: v1
kind: Service
metadata:
  name: andrew-api-service
spec:
  selector:
    tier: andrew-api
  type: ClusterIP
  ports:
    - port: 3000
      targetPort: 3000
      name: public
    - port: 3001
      targetPort: 3001
      name: private
  YAML
}


resource "kubectl_manifest" "andrew_staging_api_ingress" {
  depends_on = [kubectl_manifest.andrew_staging_namespace]
  yaml_body  = <<YAML
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: andrew-api-ingress
  annotations:
    cert-manager.io/issuer: cert-manager-andrew-staging-issuer
    kubernetes.io/ingress.class: nginx
spec:
  tls:
    - hosts:
        - andrew-api.students-epitech.ovh
      secretName: tls-andrew-api
  rules:
    - host: andrew-api.students-epitech.ovh
      http:
        paths:
          - path: /swagger/private
            pathType: Prefix
            backend:
              service:
                name: andrew-api-service
                port:
                  number: 3001
          - path: /
            pathType: Prefix
            backend:
              service:
                name: andrew-api-service
                port:
                  number: 3000
  YAML
}

resource "kubectl_manifest" "andrew_staging_api_deployment" {
  depends_on = [kubectl_manifest.andrew_staging_api_secret, kubectl_manifest.andrew_staging_api_configmap]
  yaml_body  = <<YAML
apiVersion: apps/v1
kind: Deployment
metadata:
  name: andrew-api-deployment
  labels:
    tier: andrew-api
spec:
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  replicas: 1
  selector:
    matchLabels:
      tier: andrew-api
  template:
    metadata:
      labels:
        tier: andrew-api
    spec:
      containers:
        - name: andrew-api
          image: antoineleguillou/andrew-api:v0.6.5
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
                name: andrew-api-configmap
            - secretRef:
                name: andrew-api-secrets
          ports:
            - containerPort: 3000
            - containerPort: 3001
      restartPolicy: Always
  YAML
}

resource "kubectl_manifest" "andrew_staging_api_contract_discount_cronjob" {
  depends_on = [kubectl_manifest.andrew_staging_api_deployment]
  yaml_body  = <<YAML
apiVersion: batch/v1
kind: CronJob
metadata:
  name: andrew-api-contract-discount
spec:
  schedule: "0 0 1 * *"
  successfulJobsHistoryLimit: 0
  failedJobsHistoryLimit: 1
  concurrencyPolicy: Forbid
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: andrew-api-contract-discount
              image: antoineleguillou/alpine-curl:latest
              imagePullPolicy: IfNotPresent
              command: 
                - /bin/sh 
                - -c 
                - curl -X POST -v http://andrew-api-service.andrew-staging.svc.cluster.local:3001/contract-discount
          restartPolicy: Never
  YAML
}
