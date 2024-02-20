# AWS Load Balancer Controller using ALB Ingress
# minimal settings needed to run gitlab on ALB
# Note that when using an ALB ingress controller we need to use a separate NLB for gitlab-shell (ssh) connections.

# Enable/Disable cert-manager
certmanager:
  install: false

# Disable nginx-ingress
nginx-ingress:
  enabled: false
# Common settings for AWS Load Balancer Controller
# You've disabled the installation of Redis. When using an external Redis.
# You must populate `global.redis.host` or `gitlab.redis.redisYmlOverride`.
global:
  redis:
    auth:
      enabled: false
    host: redis.roboshop.com

  edition: ce #this must be ce or ee

  hosts:
    domain: decodedevops.com
    # we need a different dns endpoint for webservice and ssh
    ssh: gitlab-shell.decodedevops.com
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

redis:
  install: false
