# Put the json file on files folder

resource "aws_ssm_parameter" "ssm" {
  name  = "${var.prefix}-terraform-ssm"
  type  = "SecureString"
  value = file("${path.module}/files/${var.creds_file}")
}