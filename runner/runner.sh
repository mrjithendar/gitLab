# https://docs.gitlab.com/runner/install/kubernetes.html

GITLABRUNNERKEY=
# kubectl create secret generic s3access \
#     --from-literal=accesskey="" \
#     --from-literal=secretkey="" -n gitlab


helm repo add gitlab https://charts.gitlab.io

helm init

helm repo update gitlab

helm search repo -l gitlab/gitlab-runner

# For Helm 3
helm install -n gitlab gitlab-runner -f runner/values.yml gitlab/gitlab-runner \
    --set "runnerRegistrationToken=$GITLABRUNNERKEY"

helm upgrade --install -n gitlab gitlab-runner -f runner/values.yml gitlab/gitlab-runner \
    --set "runnerRegistrationToken=$GITLABRUNNERKEY"

