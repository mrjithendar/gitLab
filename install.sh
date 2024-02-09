#!/bin/bash

# link https://argo-cd.readthedocs.io/en/stable/getting_started/#1-install-argo-cd

echo "checking gitlab status"
helm ls -n gitlab | grep gitlab

if [ $? -eq 0 ]; then
  echo "gitlab installed already, trying to upgrade gitlab."
  helm upgrade gitlab gitlab/gitlab -n gitlab --create-namespace=true #--values values.yml
  PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password --ojsonpath=’{.data.password}’)
  echo "gitlab Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
  else
    echo "gitlab installing"
    helm repo add gitlab https://charts.gitlab.io/
    helm repo update
    helm install gitlab gitlab/gitlab -n gitlab --create-namespace=true --values values.yml
    sleep 10
    echo "gitlab installed successfully"
    PASSWORD=$(kubectl get secret gitlab-gitlab-initial-root-password --ojsonpath=’{.data.password}’)
    echo "gitlab Credentials Username: admin and Password is: $(echo $PASSWORD | base64 --decode)"
fi

