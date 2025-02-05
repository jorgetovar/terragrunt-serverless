

provider "aws" {
  region = "us-east-1"
}

module "lambda_function" {
  source  = "terraform-aws-modules/lambda/aws"
  version = "~> 6.0"

  function_name = "${random_pet.this.id}-lambda"
  description   = "My awesome lambda function"
  handler       = "index.lambda_handler"
  runtime       = "python3.11"
  publish       = true
  source_path = "${path.module}/python"

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.apigatewayv2_api_execution_arn}/*/*"
    }
  }

  tags = {
    Pattern = "terraform-apigw-http-lambda"
    Module  = "lambda_function"
  }
}

module "api_gateway" {
  source  = "terraform-aws-modules/apigateway-v2/aws"
  version = "~> 3.0"

  name          = "${random_pet.this.id}-http"
  description   = "My awesome HTTP API Gateway"
  protocol_type = "HTTP"
  
  create_api_domain_name = false

  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  integrations = {
    "ANY /" = {
      lambda_arn             = module.lambda_function.lambda_function_arn
      payload_format_version = "2.0"
    }
  }

  tags = {
    Pattern = "terraform-apigw-http-lambda"
    Module  = "api_gateway"
  }
}

resource "random_pet" "this" {
  length = 2
}