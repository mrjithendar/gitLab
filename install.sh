#!/bin/bash

# link https://docs.gitlab.com/charts/quickstart/
# https://docs.gitlab.com/charts/installation/command-line-options.html


APP="gitlab"
DOMAIN="decodedevops.com"

echo "checking $APP status"
helm ls -n $APP | grep $APP

if [ $? -eq 0 ]; then
  echo "$APP installed already, trying to upgrade $APP."
  helm upgrade $APP $APP/$APP -n $APP --set global.hosts.domain=$DOMAIN \
       --set certmanager-issuer.email=team@$DOMAIN --set global.edition=ce \
       --set postgresql.image.tag=13.6.0 --create-namespace
  echo "$APP upgraded successfully"
  kubectl get svc -l app=nginx-ingress -n $APP
  PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
  echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
  else
    echo "$APP installing"
    helm repo add $APP https://charts.$APP.io/
    helm repo update
    helm install $APP $APP/$APP -n $APP --set global.hosts.domain=$DOMAIN \
         --set certmanager-issuer.email=team@$DOMAIN --set global.edition=ce \
         --set postgresql.image.tag=13.6.0 --create-namespace
    sleep 10
    echo "$APP installed successfully"
    kubectl get svc -l app=nginx-ingress -n $APP
    
    PASSWORD=$(kubectl get secret $APP-$APP-initial-root-password -o jsonpath='{.data.password}' -n $APP)
    echo "$APP Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
fi

# aws route53 change-resource-record-sets \
#   --hosted-zone-id Z10022573QBDSVQJ5PP1F \
#   --change-batch '{"Changes":[{"Action":"CREATE","ResourceRecordSet":{"Name":"example.com.","Type":"A","TTL":300,"ResourceRecords":[{"Value":"<IPv4 address>"}]}}]}'