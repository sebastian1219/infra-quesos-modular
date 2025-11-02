output "bucket_name" {
  value = module.s3_backend.s3_bucket_id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.tf_lock.name
}
