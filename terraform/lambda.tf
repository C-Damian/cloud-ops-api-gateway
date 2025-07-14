resource "aws_iam_role" "lambda_role" {
  name = "fastapi_lambda_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
  
}

# Attach basic Lambda execution policy
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Create a ZIP of your code
data "archive_file" "lambda_zip" {
  type = "zip"
  source_dir = "../" # Points to your project root
  output_path = "fastapi_lambda.zip"
  excludes = [
    "terraform/**",
    ".git/**",
    ".venv/**",
    "__pycache__/**",
    ".env/**",
  ]
}

# The actual Lambda function
resource "aws_lambda_function" "fastapi_lambda" {
  filename = data.archive_file.lambda_zip.output_path
  function_name = "fastapi_cloud_ops"
  role = aws_iam_role.lambda_role.arn
  handler = "main.handler" # Points to our handler in main.py
  runtime = "python3.9"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout = 30
}