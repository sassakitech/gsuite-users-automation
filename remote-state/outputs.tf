output "aws_s3_bucket_arn" {
  value = aws_s3_bucket.remote_state.arn
}

output "aws_dynamodb_table_arn" {
  value = aws_dynamodb_table.state_lock.arn
}