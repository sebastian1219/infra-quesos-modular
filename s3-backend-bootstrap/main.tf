provider "aws" {
  region  = "us-east-1"
}

data "aws_iam_policy_document" "s3_backend_access" {
  statement {
    sid    = "AllowAssumedRolesAccessToStateFile"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::730335546358:root"]
    }

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject"
    ]

    resources = [
      "arn:aws:s3:::${var.bucket_name}/infra/terraform.tfstate"
    ]
  }

  statement {
    sid    = "AllowListBucket"
    effect = "Allow"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::730335546358:root"]
    }

    actions = ["s3:ListBucket"]

    resources = ["arn:aws:s3:::${var.bucket_name}"]

    condition {
      test     = "StringLike"
      variable = "s3:prefix"
      values   = ["infra/*"]
    }
  }
}



module "s3_backend" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"
  policy = data.aws_iam_policy_document.s3_backend_access.json

  bucket        = var.bucket_name
  force_destroy = false

  versioning = {
    enabled = true
  }

  # ✅ Eliminamos ACL para evitar conflicto con bloqueo público
  # acl = "private"  ← ❌ No se debe usar

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = "cheese-tf-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Environment = var.environment
    Project     = "cheese-factory"
  }
}

