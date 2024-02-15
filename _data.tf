data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_eks_cluster" "cluster" {
  name = local.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.ekscluster.outputs.cluster_name
}

data "http" "eks_lbc_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.7/docs/install/iam_policy.json"
  request_headers = {
    accept = "application/json"
  }
}

data "aws_iam_role" "eks_ng" {
  name = data.terraform_remote_state.ekscluster.outputs.eks_nodegroup_role
}

data "aws_s3_bucket" "logsBucket" {
  bucket = data.terraform_remote_state.ekscluster.outputs.s3logsbucket
}