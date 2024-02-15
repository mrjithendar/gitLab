output "acmArn" {
  value = data.terraform_remote_state.gitops.outputs.acm_arn
}

output "logsBucket" {
  value = data.aws_s3_bucket.logsBucket.bucket
}