resource "aws_iam_role" "iam_role" {
  name = "${var.prefix}-terraform-iam-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name = "IAM role for GSuite automation"
  }

}

resource "aws_iam_role_policy_attachment" "iam_role_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ])

  role       = aws_iam_role.iam_role.name
  policy_arn = each.value
}
