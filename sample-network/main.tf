provider "aws" {
  region = "ap-northeast-1"
}

# VPC
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "sample-vpc"
  }
}

# subnet
resource "aws_subnet" "public_1a" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1a"

  tags = {
    Name = "sample-public-1a"
  }
}

resource "aws_subnet" "public_1c" {
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1c"
  cidr_block = "10.0.2.0/24"
  tags = {
    Name = "sample-public-1c"
  }
}

resource "aws_subnet" "public_1d" {
  cidr_block = "10.0.3.0/24"
  vpc_id = aws_vpc.main.id
  availability_zone = "ap-northeast-1d"
  tags = {
    Name = "sample-public-1d"
  }
}

# private subnet
resource "aws_subnet" "private_1a" {
  cidr_block = "10.0.10.0/24"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sample-private-1a"
  }
}

resource "aws_subnet" "private_1c" {
  cidr_block = "10.0.20.0/24"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sample-private-1c"
  }
}

resource "aws_subnet" "private_1d" {
  cidr_block = "10.0.30.0/24"
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sam-le-private-1d"
  }
}

# internet gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sample-internet-gateway"
  }
}

# AZ-a
# elastic ip
resource "aws_eip" "nat_1a" {
  vpc = true
  tags = {
    Name = "sample-eip-1a"
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat_1a" {
  allocation_id = aws_eip.nat_1a.id
  subnet_id = aws_subnet.public_1a.id

  tags = {
    Name = "sample-nat-gateway-1a"
  }
}

# AZ-c
# elastic ip
resource "aws_eip" "nat_1c" {
  vpc = true
  tags = {
    Name = "sample-eip-1c"
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat_1c" {
  allocation_id = aws_eip.nat_1c.id
  subnet_id = aws_subnet.public_1c.id

  tags = {
    Name = "sample-nat-gateway-1c"
  }
}

# AZ-d
# elastic ip
resource "aws_eip" "nat_1d" {
  vpc = true
  tags = {
    Name = "sample-eip-1d"
  }
}

# NAT gateway
resource "aws_nat_gateway" "nat_1d" {
  allocation_id = aws_eip.nat_1d.id
  subnet_id = aws_subnet.public_1d.id

  tags = {
    Name = "sample-nat-gateway-1d"
  }
}

# Route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "sample-route-table"
  }
}

# Route
resource "aws_route" "public" {
  destination_cidr_block = "0.0.0.0/0"
  route_table_id = aws_route_table.public.id
  gateway_id = aws_internet_gateway.main.id
}

# Association
resource "aws_route_table_association" "public_1a" {
  subnet_id = aws_subnet.public_1a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1c" {
  subnet_id = aws_subnet.public_1c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_1d" {
  subnet_id = aws_subnet.public_1d.id
  route_table_id = aws_route_table.public.id
}

# Route Table (private)
resource "aws_route_table" "private_1a" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sample-route-table-1a"
  }
}

resource "aws_route_table" "private_1c" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sample-route-table-1c"
  }
}

resource "aws_route_table" "private_1d" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "sample-route-table-1d"
  }
}

# Route (private)
resource "aws_route" "private_1a" {
  route_table_id = aws_route_table.private_1a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_1a.id
}

resource "aws_route" "private_1c" {
  route_table_id = aws_route_table.private_1c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_1c.id
}

resource "aws_route" "private_1d" {
  route_table_id = aws_route_table.private_1d.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id = aws_nat_gateway.nat_1d.id
}

# Association(private)
resource "aws_route_table_association" "private_1a" {
  route_table_id = aws_route_table.private_1a.id
  subnet_id = aws_subnet.private_1a.id
}

resource "aws_route_table_association" "private_1c" {
  route_table_id = aws_route_table.private_1c.id
  subnet_id = aws_subnet.private_1c.id
}

resource "aws_route_table_association" "private_1d" {
  route_table_id = aws_route_table.private_1d.id
  subnet_id = aws_subnet.private_1d.id
}

# security group
resource "aws_security_group" "alb" {
  name = "sample-alb"
  description = "sample alb"
  vpc_id = aws_vpc.main.id

  # セキュリティグループ内からインターネットアクセスを許可
  egress {
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sample-alb"
  }
}

# security group rule
resource "aws_security_group_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id

  # セキュリティグループ内へインターネットアクセスを許可
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
}

# ALB
resource "aws_lb" "main" {
  load_balancer_type = "application"
  name = "sample-lb"
  security_groups = [aws_security_group.alb.id]
  subnets = [aws_subnet.public_1a.id, aws_subnet.public_1c.id, aws_subnet.public_1d.id]
}

# alb listner
resource "aws_lb_listener" "main" {
  # ALBのarnを指定
  load_balancer_arn = aws_lb.main.arn
  port = 80
  protocol = "HTTP"
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code = "200"
      message_body = "OK"
    }
  }
}

# ecs task definition
resource "aws_ecs_task_definition" "main" {
  family = "sample"

  # データプレーンの選択
  requires_compatibilities = ["FARGATE"]

  cpu = 256
  memory = 512

  # fargateを使用する場合はawsvpc
  network_mode = "awsvpc"

  # 起動コンテナ定義
  # nginxを起動し80 portを開放する
  container_definitions = <<EOL
  [
    {
      "name": "nginx",
      "image": "nginx:1.14",
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ]
    }
  ]
  EOL
}

# ECS cluster
resource "aws_ecs_cluster" "main" {
  name = "sample-ecs-cluster"
}

# ELB target group
resource "aws_lb_target_group" "main" {
  name = "sample-target-group"
  vpc_id = aws_vpc.main.id

  # ALBからECSタスクのコンテナへのトラフィック
  port = 80
  protocol = "HTTP"
  target_type = "ip"

  # コンテナへの死活監視設定
  health_check {
    port = 80
    path = "/"
  }
}

# ALB listener rule
resource "aws_lb_listener_rule" "main" {
  listener_arn = aws_lb_listener.main.arn
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.main.id
  }
  # ターゲットグループへ受け渡すトラフィックの条件
  condition {
    path_pattern {
      values = ["*"]
    }
  }
}

# security group
resource "aws_security_group" "ecs" {
  name = "sample-ecs"
  description = "sample-ecs"

  vpc_id = aws_vpc.main.id

  # セキュリティグループ内からインターネットへのアクセス許可
  # DockerHubへのpullに使用
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "sample-ecs"
  }
}

# Security group rule
resource "aws_security_group_rule" "ecs" {
  security_group_id = aws_security_group.ecs.id
  type = "ingress"
  from_port = 80
  to_port = 80
  protocol = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
}

# ecs service
resource "aws_ecs_service" "main" {
  name = "sample-ecs-service"
  depends_on = [aws_lb_listener_rule.main]

  cluster = aws_ecs_cluster.main.name
  launch_type = "FARGATE"
  desired_count = 1
  task_definition = aws_ecs_task_definition.main.arn
  # ECSタスクへ設定するネットワークの設定
  network_configuration {
    subnets = [aws_subnet.private_1a.id, aws_subnet.private_1c.id, aws_subnet.private_1d.id]
    security_groups = [aws_security_group.ecs.id]
  }

  # ECSタスク起動時に紐付けるELBターゲットグループ
  load_balancer {
    target_group_arn = aws_lb_target_group.main.arn
    container_name = "nginx"
    container_port = 80
  }
}

