#!/bin/bash

# link https://docs.$APP.com/charts/quickstart/

APP="gitlab"

echo "checking $APP status"
helm ls -n $APP | grep $APP

if [ $? -eq 0 ]; then
  echo "$APP installed already, trying to upgrade $APP."
  helm upgrade $APP $APP/$APP -n $APP --set global.hosts.domain=$APP.decodedevops.com \
       --set certmanager-issuer.email=team@decodedevops.com --set global.edition=ce --create-namespace
  echo "$APP upgraded successfully"
  kubectl get svc -l app=nginx-ingress
  PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}')
  echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
  else
    echo "$APP installing"
    helm repo add $APP https://charts.$APP.io/
    helm repo update
    helm install $APP $APP/$APP -n $APP --set global.hosts.domain=$APP.decodedevops.com \
         --set certmanager-issuer.email=team@decodedevops.com --set global.edition=ce --create-namespace
    sleep 10
    echo "$APP installed successfully"
    kubectl get svc -l app=nginx-ingress
    
    PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}')
    echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
fi

