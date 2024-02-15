#!/bin/bash

# link https://docs.gitlab.com/charts/quickstart/
# https://docs.gitlab.com/charts/installation/command-line-options.html


APP="gitlab"
DOMAIN="decodedevops.com"

echo "checking $APP status"
helm ls -n $APP | grep $APP

if [ $? -eq 0 ]; then
  echo "$APP installed already, trying to resinstall $APP."
  # helm show values gitlab/gitlab > values.yml
  helm delete gitlab -n gitlab
  helm upgrade --install $APP $APP/$APP -n $APP --create-namespace --values=k8s/alb-full.yml
  echo "$APP upgraded successfully"
  kubectl get ingress -lrelease=gitlab -n $APP
  PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
  echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
  else
    echo "$APP Helm repos add/update is in progress"
    helm repo add $APP https://charts.$APP.io/
    helm repo update
    echo "$APP installing please wait"
    # helm show values gitlab/gitlab > values.yml
    helm install $APP $APP/$APP -n $APP --create-namespace --values=k8s/alb-full.yml
    sleep 10
    echo "$APP installed successfully"
    kubectl get ingress -lrelease=gitlab -n $APP
    
    PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
    echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
fi




# kubectl get namespace "gitlab" -o json | tr -d "\n" | sed "s/\"finalizers\": \[[^]]\+\]/\"finalizers\": []/" | kubectl replace --raw /api/v1/namespaces/gitlab/finalize -f -