terraform {
  source = "../../modules/lambda-api"
}
inputs = {
  lambda_description = "My awesome Lambda Function"
}