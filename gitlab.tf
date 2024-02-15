resource "helm_release" "gitlab" {
  repository       = "https://charts.gitlab.io/"
  chart            = "gitlab"
  name             = "gitlab"
  namespace        = "gitlab"
  create_namespace = true
  values           = [ data.template_file.gitlab.rendered ]
}

data "template_file" "gitlab" {
  template = file("${path.module}/k8s/alb-full.tpl")
  vars = {
    acm_arn = data.terraform_remote_state.gitops.outputs.acm_arn
    logsBucket = data.aws_s3_bucket.logsBucket.bucket
  }
}

output "name" {
  value = data.terraform_remote_state.gitops.outputs.acm_arn
}