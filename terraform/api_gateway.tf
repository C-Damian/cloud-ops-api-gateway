#api gateway instance
resource "aws_apigatewayv2_api" "fastapi_gateway" {
  name = "fastapi_cloud_ops_api"
  protocol_type = "HTTP" # HTTP API (cheaper/faster than REST API)
  description = "API gateway for FastAPI cloud ops app"
}

# Integration - tells API Gateway HOW to connect to your Lambda
resource "aws_apigatewayv2_integration" "lambda_integration" {
  api_id = aws_apigatewayv2_api.fastapi_gateway.id
  integration_type = "AWS_PROXY" # Passes full HTTP request to Lambda as event
  integration_uri = aws_lambda_function.fastapi_lambda.invoke_arn
}
# aws proxy integration, this will route all http requests to lambda and expects a response, all of this is converted by magnum

# Route - tells API Gateway the requests to send to your Lambda
resource "aws_apigatewayv2_route" "proxy_route" { 
  api_id = aws_apigatewayv2_api.fastapi_gateway.id
  route_key = "ANY /{proxy+}"  # Catch ALL methods (GET/POST/etc) and ALL paths
  target = "integrations/${aws_apigatewayv2_integration.lambda_integration.id}"
}

# set permissions to allow APIgateway to invoke our Lambda func
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id = "AllowExecutionFromAPIGateway"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.fastapi_lambda.function_name
  principal = "apigateway.amazonaws.com" # this says who can invoke it
  source_arn = "${aws_apigatewayv2_api.fastapi_gateway.execution_arn}/*/*" # this says from where
}

# stage resource, this creates a stage and URL that can be called, making the API accesible from the internet
resource "aws_apigatewayv2_stage" "default" {
  api_id = aws_apigatewayv2_api.fastapi_gateway.id
  name = "$default"
  auto_deploy = true # automatically deploys changes
}