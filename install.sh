#!/bin/bash

# link https://docs.gitlab.com/charts/quickstart/

echo "checking gitlab status"
helm ls -n gitlab | grep gitlab

if [ $? -eq 0 ]; then
  echo "gitlab installed already, trying to upgrade gitlab."
  helm upgrade gitlab gitlab/gitlab --set global.hosts.domain=gitlab.decodedevops.com \
       --set certmanager-issuer.email=team@decodedevops.com --set global.edition=ce \
       --create-namespace true -n gitlab
  echo "gitlab upgraded successfully"
  kubectl get svc -l app=nginx-ingress
  PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}')
  echo "gitlab Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
  else
    echo "gitlab installing"
    helm repo add gitlab https://charts.gitlab.io/
    helm repo update
    helm install gitlab gitlab/gitlab --set global.hosts.domain=gitlab.decodedevops.com \
         --set certmanager-issuer.email=team@decodedevops.com --set global.edition=ce \
         --create-namespace true -n gitlab
    sleep 10
    echo "gitlab installed successfully"
    kubectl get svc -l app=nginx-ingress
    
    PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password -o jsonpath='{.data.password}')
    echo "gitlab Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
fi

