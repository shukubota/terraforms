terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "3.54.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/apigatewayv2_api

resource "aws_apigatewayv2_api" "example"  {
  name = "example-websocket-gateway"
  protocol_type = "WEBSOCKET"
  route_selection_expression = "$request.body.action"
}