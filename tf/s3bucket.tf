
resource "aws_s3_bucket" "gitlab-registry" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-gitlab-registry"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Registry"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "gitlab-runner-cache" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-runner-cache"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Runner Cache"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "gitlab-backups" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-gitlab-backups"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Backups"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "gitlab-pseudo" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-gitlab-pseudo"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Pseudo"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "git-lfs" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-git-lfs"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Git Large File Storage"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "gitlab-artifacts" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-gitlab-artifacts"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Artifacts"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "gitlab-uploads" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-gitlab-uploads"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Uploads"
    Environment = "core"
  }
}

resource "aws_s3_bucket" "gitlab-packages" {
  bucket = "${data.aws_caller_identity.current.account_id}-${var.region}-gitlab-packages"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags = {
    Name        = "Gitlab Packages"
    Environment = "core"
  }
}