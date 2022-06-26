# Insert the prefix name for the created services
variable "prefix" {
  default = "gsuite-automation"
}

# Insert the name with extension .zip (after we will use this to lambda function)
variable "lambda_file" {
  default = "lambda_function.zip"
}

# Insert the name with extension .json (to authentication on API Google)
variable "creds_file" {
  default = "credentials.json"
}

# Delegated privileged account with SuperAdmin access on Admin GSuite to service account
variable "delegated_account" {
  default = "type delegated account here"
}

# Stage name for API requests
variable "prod_stage" {
  default = "prod"
}

# AWS region
variable "aws_region" {
  default = "us-west-2"
}
