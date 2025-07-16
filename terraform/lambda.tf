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
# data "archive_file" "lambda_zip" {
#  type = "zip"
#  source_dir = "../" # Points to your project root
#  output_path = "fastapi_lambda.zip"
#  excludes = [
#    "terraform/**",
#    ".git/**",
#    ".venv/**",
#    "__pycache__/**",
#    ".env/**",
#  ]
#}

#New approach to packaging lambda with null resurce since I encountered issues with archive_file
resource "null_resource" "lambda_package" {
  triggers = {
    main_py = filebase64sha256("${path.module}/../main.py")
    auth_py = filebase64sha256("${path.module}/../auth.py")
    requirements = filebase64sha256("${path.module}/../lambda_reqs.txt")
  }

# Build lambda package
  provisioner "local-exec" {
    command = <<-EOT
      echo "=== Starting Lambda package build ==="
      pwd
      rm -f fastapi_lambda.zip
      rm -rf lambda_package
      mkdir -p lambda_package
      cp ../main.py lambda_package/
      cp ../auth.py lambda_package/
      echo "=== Installing dependencies for Linux platform ==="
      pip install -r ../lambda_reqs.txt -t lambda_package/ --platform linux_x86_64 --only-binary=:all: --no-cache-dir
      echo "=== Creating zip file ==="
      cd lambda_package && zip -r ../fastapi_lambda.zip . && cd ..
      echo "=== Cleaning up ==="
      rm -rf lambda_package
      echo "=== Build complete ==="
    EOT
    working_dir = path.module
  }
}
# The actual Lambda function
resource "aws_lambda_function" "fastapi_lambda" {
  depends_on = [null_resource.lambda_package] # Ensure package is built first
  filename = "${path.module}/fastapi_lambda.zip"
  function_name = "fastapi_cloud_ops"
  role = aws_iam_role.lambda_role.arn
  handler = "main.handler" # Points to our handler in main.py
  runtime = "python3.11"
  timeout = 30
  
}