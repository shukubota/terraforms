# AWSプロバイダの定義
provider "aws" {
  region = "ap-northeast-1"
}

# VPCを作成する
resource "aws_vpc" "main" { # "main" という命名を行う
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "vpc-sample"
  }
}

# Subnetを作成する
resource "aws_subnet" "main" { # 別のリソースであれば命名が被っていても問題ないです
  vpc_id     = "${aws_vpc.main.id}" # aws_vpc.mainでmainと命名されたVPCを参照し、そのVPCのIDを取得する
  cidr_block = "10.0.1.0/24"
}