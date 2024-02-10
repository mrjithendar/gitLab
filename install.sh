#!/bin/bash

# link https://docs.gitlab.com/charts/quickstart/
# https://docs.gitlab.com/charts/installation/command-line-options.html


APP="gitlab"
DOMAIN="decodedevops.com"

echo "checking $APP status"
helm ls -n $APP | grep $APP

if [ $? -eq 0 ]; then
  echo "$APP installed already, trying to upgrade $APP."
  # helm show values gitlab/gitlab > values.yml
  helm upgrade $APP $APP/$APP -n $APP --create-namespace --values=values.yml
  echo "$APP upgraded successfully"
  kubectl get ingress -lrelease=gitlab -n $APP
  PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
  echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
  else
    echo "$APP installing"
    helm repo add $APP https://charts.$APP.io/
    helm repo update
    # helm show values gitlab/gitlab > values.yml
    helm install $APP $APP/$APP -n $APP --create-namespace --values=values.yml
    sleep 10
    echo "$APP installed successfully"
    kubectl get ingress -lrelease=gitlab -n $APP
    
    PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
    echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
fi