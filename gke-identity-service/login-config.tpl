apiVersion: authentication.gke.io/v2alpha1
kind: ClientConfig
metadata:
  name: default
  namespace: kube-public
spec:
  certificateAuthorityData: ${certificateAuthorityData}
  name: our-monolith-428715-r1-gke
  server: https://auth.k8s.api.students-epitech.ovh
  authentication:
    - name: oidc
      oidc:
        clientID: ${clientId}
        clientSecret: ${clientSecret}
        issuerURI: https://auth.students-epitech.ovh/realms/kubernetes
        cloudConsoleRedirectURI: https://console.cloud.google.com/kubernetes/oidc
        kubectlRedirectURI: http://localhost:8000/callback
        scopes: openid email profile offline_access
        userClaim: email
        groupsClaim: roles
        userPrefix: ""
        groupPrefix: ""
status: {}