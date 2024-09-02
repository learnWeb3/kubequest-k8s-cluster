# kubequest k8s cluster

This repository contains a terraform code to describe the kubequest kubernetes internal services.
Variables values are encrypted and unencrypted file version is kept locally as a secret.tfvars file referencing secrets variables values for the cluster.

The terraform output a file called login_config.yaml at the root of the directory.

This file allows assigned users to the kubequest application from the epitech microsoft entra id tenant to access the cluster using SSO from their microsoft epitech account with readonly scoped access to the kubernernetes cluster.

## Quick start

```bash
# set variable and create secret.tfvars containing variables
export GOOGLE_PROJECT_REGION="<VALUE HERE>"
export GOOGLE_PROJECT_ID="<VALUE HERE>"
export K8S_CACERT="<VALUE HERE>"
export K8S_TOKEN="<VALUE HERE>"
export K8S_HOST="<VALUE HERE>"
export APP_KEY="<VALUE HERE>"
export DB_PASSWORD="<VALUE HERE>"
export DB_USERNAME="<VALUE HERE>"
export DB_ROOT_PASSWORD="<VALUE HERE>"
export ALERT_MANAGER_MAIL_USERNAME="<VALUE HERE>"
export export ALERT_MANAGER_MAIL_PASSWORD="<VALUE HERE>"
export PROMETHEUS_GRAFANA_ADMIN_PASSWORD="<VALUE HERE>"
export GCS_BUCKET_NAME_MYSQL_BACKUP="<VALUE HERE>"
export GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP="<VALUE HERE>"
export GCS_PROJECT_ID_MYSQL_BACKUP="<VALUE HERE>"
export KEYCLOAK_PG_ROOT_PASSWORD="<VALUE HERE>"
export KEYCLOAK_PG_USER_PASSWORD="<VALUE HERE>"
export KEYCLOAK_PG_REPLICATION_PASSWORD="<VALUE HERE>"
export KEYCLOAK_UI_ADMIN_PASSWORD="<VALUE HERE>"
export MS_TEAMS_WEBHOOK_URL="<VALUE HERE>"
touch ./secret.tfvars && echo "GOOGLE_PROJECT_REGION=$GOOGLE_PROJECT_REGION\nGOOGLE_PROJECT_ID=$GOOGLE_PROJECT_ID\nK8S_CACERT=$K8S_CACERT\nK8S_TOKEN=$K8S_TOKEN\nK8S_HOST=$K8S_HOST\nAPP_KEY=$APP_KEY\nDB_PASSWORD=$DB_PASSWORD\nDB_USERNAME=$DB_USERNAME\nDB_ROOT_PASSWORD=$DB_ROOT_PASSWORD\nALERT_MANAGER_MAIL_USERNAME=$ALERT_MANAGER_MAIL_USERNAME\nALERT_MANAGER_MAIL_PASSWORD=$ALERT_MANAGER_MAIL_PASSWORD\nPROMETHEUS_GRAFANA_ADMIN_PASSWORD=$PROMETHEUS_GRAFANA_ADMIN_PASSWORD\nGCS_BUCKET_NAME_MYSQL_BACKUP=$GCS_BUCKET_NAME_MYSQL_BACKUP\nGCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP=$GCS_SERVICE_ACCOUNT_JSON_KEY_MYSQL_BACKUP\nGCS_PROJECT_ID_MYSQL_BACKUP=$GCS_PROJECT_ID_MYSQL_BACKUP\nKEYCLOAK_PG_ROOT_PASSWORD=$KEYCLOAK_PG_ROOT_PASSWORD\nKEYCLOAK_PG_USER_PASSWORD=$KEYCLOAK_PG_USER_PASSWORD\nKEYCLOAK_PG_REPLICATION_PASSWORD=$KEYCLOAK_PG_REPLICATION_PASSWORD\nKEYCLOAK_UI_ADMIN_PASSWORD=$KEYCLOAK_UI_ADMIN_PASSWORD\nMS_TEAMS_WEBHOOK_URL=$MS_TEAMS_WEBHOOK_URL" > ./secret.tfvars
# create a file to store the secret values
touch secret.tfvars
# encrypt the secret.tfvars config file
gpg --symmetric --cipher-algo AES256 secret.tfvars
# inialize terraform
terraform init
# refresh terraform state
terraform refresh
# plan terraform required operations to achieve desired state
terraform plan
# apply the changes
terraform apply -var-file="secret.tfvars"
# import existing resources into the terraform state (helm chart example)
terraform import -var-file=secret.tfvars module.commons.helm_release.cert_manager cert-manager/cert-manager
# import existing resources into the terraform state (k8s resource example)
terraform import -var-file=secret.tfvars module.<module_name>.<resource_provider>.<resource_name> <api>//<kind>//<resource name>//<namespace>
```

## Services breakdown

### kubequest application

The kubequest application is a basic PHP laravel 8 application with a minor version greater than 75.

It is exposed on port 80, follow an Model View Controller (MVC) standard architectural pattern and interacts with a Mysql database storage.

The application has been containerized using Docker and a docker-compose helps us run the application with its mysql database service in development.

You can access a detailed overview [here](../kubequest-application/README.md)

### mysql database

The mysql database is deployed using the [mysql bitpoke operator](https://www.bitpoke.io/docs/mysql-operator/) to manageall the necessary resources for deploying and managing a highly available MySQL cluster using the Master/Slave Replication architecture. It also provides effortless backups.

[Diagram](./documentation/mysql_replication_architecture.png)

### Prometheus stack (Monitoring stack)

In order to monitor cluster resources we have chosen to use prometheus stack wich consist of the following components :

- prometheus API server: HTTP server responsible for pulling data from exporters defined metrics endpoints (default is /metrics)
- prometheus etcd database: Time series database responsible for storing exporters metrics pulled by the prometheus API server, it uses the PromQL query language.
- prometheus node exporters: Entities responsible for gathering metrics on systems and exposing them to a defined HTTP endpoint (default is metrics)
- prometheus alert manager: Entity responsible for emitting alerts on configured channel when specific conditions are met
- prometheus ui dashboard: Entity responsible for presenting an administrator UI for the collected data and endpoints scrapped by the prometheus API server
- grafana dashboard: Entity responsible for presenting data in more elegant/efficient way than the one provided by prometheus, it uses the PromQL query language.
- exporters: In order to exports metrics understandable by prometheus stack (aka PROMQL compliant metrics) we will make the use of prometheus exporters which will act as translators between service generated metrics and prometheus compliant metrics.
  - The blackbox exporter allows blackbox probing of endpoints over HTTP, HTTPS, DNS, TCP, ICMP and gRPC.$
  - Prometheus exporter for MySQL server metrics.

The prometheus stack components are deployed using the [kube prometheus stack helm chart](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack) it installs the [kube-prometheus stack](https://github.com/prometheus-operator/kube-prometheus), a collection of Kubernetes manifests, [Grafana](http://grafana.com/) dashboards, and [Prometheus rules](https://prometheus.io/docs/prometheus/latest/configuration/recording_rules/) combined with documentation and scripts to provide easy to operate end-to-end Kubernetes cluster monitoring with [Prometheus](https://prometheus.io/) using the [Prometheus Operator](https://github.com/prometheus-operator/prometheus-operator).

[Simple Diagram](./documentation/prometheus-grafana-architecture-diagram.png)
[Diagram](./documentation/prometheus-stack-architecture.png)

### Loki (Logs Aggregation)

Loki is an efficient logs aggregation solution that optimize logs ingestion through efficient indexation.
It is compliant with the Open Telemetry specification.

It is deployed in simple scalable mode here.

Loki’s simple scalable deployment mode separates execution paths into:

- read targets
- write targets
- backend targst.

These targets can be scaled independently, letting you customize your Loki deployment to meet your business needs for log ingestion and log query so that your infrastructure costs better match how you use Loki.

The simple scalable deployment mode can scale up to a few TBs of logs per day, however if you go much beyond this, the microservices mode will be a better choice for most users.

[Diagram](./documentation/loki_architecture_components.svg)

### Grafana Alloy (Logs ingestion ands shipping)

Grafana Alloy is an agent which ships the contents of local logs to a private Grafana Loki instance or Grafana Cloud.

[Diagram](./documentation/flow-diagram-small-alloy.png)

### RBAC: K8s API server authentication/authorization using external oauth2 compliant provider (Keycloak) and Microsoft Entra ID

We leverages the kubernetes api server JWT Authenticator, an authenticator to authenticate Kubernetes users using JWT compliant tokens. The authenticator will attempt to parse a raw ID token, verify it's been signed by the configured issuer. The public key to verify the signature is discovered from the issuer's public endpoint using OIDC discovery.

Our configuration leverages this kubernetes api server feature in order to grant OIDC compliant third party server (keycloak) authenticated users access to the cluster according 3 groups readonly (readonly access to the kubequest and mysql namespace), developpers (main kubernetes resources read write edit/update access to the kubequest and mysql namespace) and admins (full access to the kubernetes cluster)

Leveraging Role Based Access Control (RBAC) kubernetes API's external authenticated access has been configured in the cluster with the following user groups:

- an admins group allowed to manage (all CRUD operations) for the following groups (kubernetes API paths):

  - apps
  - batch
  - apiextensions.k8s.io
  - networking.k8s.io
  - storage.k8s.io
  - rbac.authorization.k8s.io

- a developers group allowed to manage (all CRUD operations) for the following groups (kubernetes API paths) and scoped to the kubequest and mysql namespaces:

  - apps
  - batch
  - apiextensions.k8s.io
  - networking.k8s.io
  - storage.k8s.io

- a reaonly group allowed to read (Read, List, Watch operations) for the following groups (kubernetes API paths) and scoped to the kubequest and mysql namespaces:

  - apps
  - batch
  - apiextensions.k8s.io
  - networking.k8s.io
  - storage.k8s.io

Our configuration uses microsoft entra ID, the Epitech tenant, an application named "kubequest" with assigment requirement for users to be scoped to a group named "msc-pro-mrs-kubequest" in order for users to have Single Sign On (SSO) functionality from their epitech account.

- connection to the gke-oidc-envoy service (auth.api.k8s.students-epitech.ovh)

1. Install the [gcloud CLI](https://cloud.google.com/sdk/docs/install)
2. Install the kubectl-oic plugin

```bash
gcloud components install kubectl-oidc
```

3. Ask your administrator for the login_config.yaml file

4. Authenticate against external identity provider

```bash
kubectl oidc login --cluster="<cluster name in config file>" --login-config="<path to login_config.yaml>"
```

The authentication workflow is the following:

- redirection to the oidc provider login screen
- user click to authenticate using microsoft account
- redirection to microsoft login page
- user provide his account credentials
- redirection from microsoft to the identity provider
- redirection to the local server running at localhost (kubectl-oidc gcloud component) with access and id tokens provided by the identity provider
- user is authenticated from the identity provider point of view
- kubectl command is issued with id token
- gke-oidc-envoy validates id tokens against the oidc provider
- user Impersonation passing on requests to the API server
- api server authenticator validate token againts rbac resources (Role/RoleBinding - ClusterRole/ClusterRoleBinding)
- api server returns response to the request

[Kubernetes API server OIDC authentication](./documentation/kubernetes_api_server_openid_token_authentication.png)
[Kubelogin plugin Workflow diagram](./documentation/credential-plugin-diagram.png)

[Microsoft entra id OIDC authentication](./documentation/microsoft_entra_id/microsoft_entra_id_openid_connect.svg)

[Microsoft entra id app endpoints details](./documentation/microsoft_entra_id/microsoft_entra_id_kubequest_app_endpoints.png)
[Microsoft entra id app redirect uri](./documentation/microsoft_entra_id/microsoft_entra_id_kubequest_app_client_redirect_uri.png)
[Microsoft entra id app client secret](./documentation/microsoft_entra_id/microsoft_entra_id_kubequest_app_client_secret.png)

[Microsoft entra id group creation](./documentation/microsoft_entra_id/microsoft_entra_id_group_creation.png)
[Microsoft entra id app assignement requirement](./documentation/microsoft_entra_id/microsoft_entra_id_kubequest_app_assignement_requirement.png)
[Microsoft entra id group assignement](./documentation/microsoft_entra_id/microsoft_entra_id_kubequest_app_group_assignement.png)
