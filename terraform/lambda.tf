data "aws_iam_policy_document" "lambda_edge_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com",
        "edgelambda.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "lambda_edge_logging_policy" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:logs:*:*:*"]
  }
}

# IAM policy for logging from a lambda
resource "aws_iam_role_policy" "lambda_edge_logging" {
  name = "${var.lambda_name}-lambda_edge_logging"
  role = aws_iam_role.lambda_edge.id

  policy = data.aws_iam_policy_document.lambda_edge_logging_policy.json
}


resource "aws_iam_role" "lambda_edge" {
  name               = "eventcatalog_lambda_edge_cloudfront"
  assume_role_policy = data.aws_iam_policy_document.lambda_edge_assume_role.json
}

resource "aws_lambda_function" "eventcatalog_auth_lambda" {
  filename      = var.lambda_file_name
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_edge.arn
  handler       = "index.handler"
  timeout       = "5"
  publish       = true

  # The filebase64sha256() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = filebase64sha256(var.lambda_file_name)

  runtime = "nodejs12.x"

}
