provider "aws" {
  region = "ap-northeast-1"
}

variable "username" {
  type = string
  default = "speaking"
}
variable "password" {
  type = string
  default = "speakingpass"
}

# RDS
resource "aws_db_instance" "default" {
  allocated_storage    = 10
  engine               = "postgres"
  identifier = "speakingCamp"
  engine_version = "12.7"
  instance_class       = "db.t3.micro"
  name                 = "speakingCamp"
  username             = var.username
  password             = var.password
  skip_final_snapshot  = true
}