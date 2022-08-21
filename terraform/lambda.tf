##
## Configure the Lambda function and related resources.
##

###
### Set up IAM role and policies for the lambda
###

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

# Define the IAM role for logging from the Lambda function.
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

# Add IAM policy for logging to the iam role
resource "aws_iam_role_policy" "lambda_edge_logging" {
  name = "${local.lambda_name}-lambda_edge_logging"
  role = aws_iam_role.lambda_edge.id

  policy = data.aws_iam_policy_document.lambda_edge_logging_policy.json
}


# Create the iam role for the lambda function
resource "aws_iam_role" "lambda_edge" {
  name               = "${local.lambda_name}_lambda_edge_cloudfront"
  assume_role_policy = data.aws_iam_policy_document.lambda_edge_assume_role.json
}

# Create the lambda@edge function
resource "aws_lambda_function" "edge" {
  filename      = var.lambda_file_name
  function_name = local.lambda_name
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
