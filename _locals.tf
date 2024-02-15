locals {
  common_tags = merge(local.our_tags, var.level != "" ? tomap({ "Level" = trimprefix(var.level, "-") }) : tomap({}))
  our_tags = {
    Team         = "JITH"
    Userid       = "${lower(var.userid)}"
    Owner        = "Jithendar"
    Email        = "${var.email}"
    Environment  = "${var.environment}"
    Organization = "Jithendar and Co"
    Createdby    = "Terraform"
    Role         = "Trainer"
  }
  cluster_name     = data.terraform_remote_state.ekscluster.outputs.cluster_name
  cluster_id       = data.terraform_remote_state.ekscluster.outputs.cluster_id
  cluster_endpoint = data.terraform_remote_state.ekscluster.outputs.cluster_endpoint
  name_prefix      = "roboshop"
  name_suffix      = var.environment
}
