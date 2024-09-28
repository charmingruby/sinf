###################
# LAMBDAS         #
###################
data "aws_iam_policy_document" "lambda_assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      identifiers = ["lambda.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_iam_role" "lambda_role" {
  name               = "${var.project_resource_naming}-lambda-role"
  assume_role_policy = data.aws_iam_policy_document.lambda_assume_role_policy.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_resource_naming}-lambda-role"
    }
  )
}

###################
# CLOUDWATCH      #
###################
data "aws_iam_policy_document" "create_logs_cloudwatch_policy_document" {
  statement {
    sid       = "AllowCreatingLogGroups"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:*"]
    actions   = ["logs:CreateLogGroup"]
  }

  statement {
    sid       = "AllowWritingLogs"
    effect    = "Allow"
    resources = ["arn:aws:logs:*:*:log-group:/aws/lambda/*:*"]

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]
  }
}

resource "aws_iam_policy" "create_logs_cloudwatch_policy" {
  name   = "${var.project_resource_naming}-policy"
  policy = data.aws_iam_policy_document.create_logs_cloudwatch_policy_document.json

  tags = merge(
    var.tags,
    {
      Name = "${var.project_resource_naming}-create-logs-cloudwatch-policy"
    }
  )
}

resource "aws_iam_role_policy_attachment" "create_logs_cloudwatch_policy_attachment" {
  policy_arn = aws_iam_policy.create_logs_cloudwatch_policy.arn
  role       = aws_iam_role.lambda_role.id
}
