provider "aws" {
  region = "ap-northeast-1"
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api

resource "aws_api_gatewayv2_api" "example" {
  name = "example-websocket-gateway"
  protocol_type = "WEBSOCKET"
  role_selection_expression = "$request.body.action"
}
