# AWS Load Balancer Controller using ALB Ingress
# minimal settings needed to run gitlab on ALB
# Note that when using an ALB ingress controller we need to use a separate NLB for gitlab-shell (ssh) connections.

# Enable/Disable cert-manager
certmanager:
  install: false

# Disable nginx-ingress
nginx-ingress:
  enabled: false

global:

  ## https://docs.gitlab.com/charts/charts/globals#outgoing-email
  ## Outgoing email server settings
  smtp:
    enabled: true
    address: smtp-relay.brevo.com
    port: 587
    user_name: "jithendardharmapuri@gmail.com"
    ## https://docs.gitlab.com/charts/installation/secrets#smtp-password
    password:
      secret: "smtp-password"
      key: password
    # domain:
    authentication: "plain"
    starttls_auto: false
    openssl_verify_mode: "peer"
    open_timeout: 30
    read_timeout: 60
    pool: false

  ## https://docs.gitlab.com/charts/charts/globals#outgoing-email
  ## Email persona used in email sent by GitLab
  email:
    from: "gitlab@decodedevops.com"
    display_name: GitLab
    reply_to: "team@decodedevops.com"
    subject_suffix: ""
    smime:
      enabled: false
      secretName: ""
      keyName: "tls.key"
      certName: "tls.crt"

  time_zone: UTC ## Timezone for containers.

  edition: ce #this must be ce or ee

  hosts:
    domain: decodedevops.com # git works on https://gitlab.decodedevops.com
    ssh: gitlab-shell.decodedevops.com # we need a different dns endpoint for webservice and ssh

  ingress:
    # Common annotations used by kas, registry, and webservice
    annotations:
      alb.ingress.kubernetes.io/backend-protocol: HTTP
      alb.ingress.kubernetes.io/certificate-arn: ${acm_arn}
      alb.ingress.kubernetes.io/group.name: roboshop
      alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS": 443}]'
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      # kubernetes.io/ingress.class: alb #depriciated can use spec.ingressClassName: alb
      nginx.ingress.kubernetes.io/connection-proxy-header: "keep-alive"
    class: alb # set the spec.ingressClassName to alb
    configureCertmanager: false
    enabled: true
    path: /*
    pathType: ImplementationSpecific
    provider: aws
    tls:
      enabled: false
gitlab:
  # GitLab KAS stands for Kubernetes agent server. 
  # It's a component that's installed with GitLab and is used to manage the GitLab agent for Kubernetes. 
  # KAS is responsible for:
    # Accepting requests from agentk
    # Querying GitLab RoR to authenticate requests from agentk
    # Fetching the agent's configuration file from a corresponding Git repository
  kas:
    enabled: true
    ingress:
      # Specific annotations needed for kas service to support websockets
      annotations:
        alb.ingress.kubernetes.io/healthcheck-path: /liveness
        alb.ingress.kubernetes.io/healthcheck-port: "8151"
        alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
        alb.ingress.kubernetes.io/load-balancer-attributes: idle_timeout.timeout_seconds=4000,routing.http2.enabled=false
        alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=86400
        alb.ingress.kubernetes.io/target-type: ip
        kubernetes.io/tls-acme: "true"
        nginx.ingress.kubernetes.io/connection-proxy-header: "keep-alive"
        nginx.ingress.kubernetes.io/x-forwarded-prefix: "/path"
    # k8s services exposed via an ingress rule to an ELB need to be of type NodePort
    service:
      type: NodePort
  webservice:
    enabled: true
    service:
      type: NodePort
  # gitlab-shell (ssh) needs an NLB
  gitlab-shell:
    enabled: true
    service:
      annotations:
        external-dns.alpha.kubernetes.io/hostname: "gitlab-shell.decodedevops.com"
        service.beta.kubernetes.io/aws-load-balancer-nlb-target-type: "ip"
        service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
        service.beta.kubernetes.io/aws-load-balancer-type: "external"
      type: LoadBalancer
registry:
  enabled: true
  service:
    type: NodePort

gitlab-runner:
  install: false # disable automatic runner installation