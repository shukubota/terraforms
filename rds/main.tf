provider "aws" {
  region = "ap-northeast-1"
}

variable "username" {
//  type = string
//  default = ""
}
variable "password" {
//  type = string
//  default = ""
}

# RDS
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "postgres"
  identifier = "speaking-camp"
  engine_version = "12.7"
  instance_class       = "db.t3.micro"
  name                 = "speakingCamp"
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true
}