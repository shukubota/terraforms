provider "aws" {
  region = "ap-northeast-1"
}

variable "username" {}
variable "password" {}

# RDS
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "postgres"
  engine_version       = "9.2"
  instance_class       = "db.t2.micro"
  name                 = "speaking-biz"
  username             = var.username
  password             = var.password
  parameter_group_name = "default.postgres9.2"
  skip_final_snapshot  = true
}