provider "aws" {
  region = "ap-northeast-1"
}

// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster
resource "aws_neptune_cluster" "demo" {
  cluster_identifier = "neptune-cluster-demo"
  engine = "neptune"
  backup_retention_period = 35
}

resource "aws_neptune_cluster_instance" "demo" {
  count              = 1
  cluster_identifier = aws_neptune_cluster.demo.id
  engine             = "neptune"
  instance_class     = "db.t3.medium"
  apply_immediately  = true
}
