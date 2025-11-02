module "s3_backend" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "3.10.1"

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

