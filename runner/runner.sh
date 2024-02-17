# https://docs.gitlab.com/runner/install/kubernetes.html

kubectl create secret generic s3access \
    --from-literal=accesskey="" \
    --from-literal=secretkey="" -n gitlab


helm repo add gitlab https://charts.gitlab.io

helm init

helm repo update gitlab

helm search repo -l gitlab/gitlab-runner

# check for existing install if found upgrade existing one, if not found install new one
helm upgrade gitlab-runner -n gitlab --set "gitlabUrl=https://$GITLABURL,runnerRegistrationToken=$GITLABRUNNERKEY" \
    gitlab/gitlab-runner -f runner/values.yml

# For Helm 3
helm install -n gitlab gitlab-runner -f runner/values.yml gitlab/gitlab-runner \
    --set "gitlabUrl=$GITLABURL,runnerRegistrationToken=$GITLABRUNNERKEY"

helm upgrade --install -n gitlab gitlab-runner -f runner/values.yml gitlab/gitlab-runner \
    --set "gitlabUrl=$GITLABURL,runnerRegistrationToken=$GITLABRUNNERKEY"

