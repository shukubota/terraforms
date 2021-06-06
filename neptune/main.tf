// https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/neptune_cluster
resource "aws_neptune_cluster" "default" {
  cluster_identifier = "neptune-cluster-demo"
  engine = "neptune"
  backup_retention_period = 5
}