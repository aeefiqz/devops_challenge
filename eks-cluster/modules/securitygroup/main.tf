resource "aws_security_group" "eks-sg" {
  name_prefix = "${var.environment}-sg"
  description = "Security group for EC2 instance"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }
}





resource "aws_security_group" "control_plane" {
  name_prefix = "${var.environment}-control-plane-"
  description = "Security group for EKS control plane"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-control-plane-sg"
  }
}

# Allow inbound HTTPS from worker nodes to control plane

resource "aws_security_group_rule" "control_plane_ingress_https_from_nodes" {
  description              = "Allow inbound HTTPS from EKS worker nodes"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_nodes.id
  security_group_id        = aws_security_group.control_plane.id
}

# Allow all outbound traffic from control plane

resource "aws_security_group_rule" "control_plane_egress" {
  description       = "Allow all outbound traffic from control plane"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.control_plane.id
}

# Security Group for Worker Nodes

resource "aws_security_group" "worker_nodes" {
  name_prefix = "${var.environment}-worker-nodes-"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-worker-nodes-sg"
  }
}

# Allow inbound traffic from other worker nodes

resource "aws_security_group_rule" "worker_nodes_ingress_self" {
  description              = "Allow inbound traffic from other worker nodes"
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_nodes.id
  security_group_id        = aws_security_group.worker_nodes.id
}

# Allow inbound traffic from control plane

resource "aws_security_group_rule" "worker_nodes_ingress_control_plane" {
  description              = "Allow inbound traffic from EKS control plane"
  type                     = "ingress"
  from_port                = 1025
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.control_plane.id
  security_group_id        = aws_security_group.worker_nodes.id
}

# Allow inbound HTTPS from control plane

resource "aws_security_group_rule" "worker_nodes_ingress_https_control_plane" {
  description              = "Allow HTTPS from EKS control plane"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.control_plane.id
  security_group_id        = aws_security_group.worker_nodes.id
}

# Allow all outbound traffic from worker nodes

resource "aws_security_group_rule" "worker_nodes_egress" {
  description       = "Allow all outbound traffic from worker nodes"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.worker_nodes.id
}

# Security Group for Load Balancer

resource "aws_security_group" "load_balancer" {
  name_prefix = "${var.environment}-alb-"
  description = "Security group for Application Load Balancer"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.environment}-load-balancer-sg"
  }
}

# Allow inbound HTTP

resource "aws_security_group_rule" "alb_ingress_http" {
  description       = "Allow inbound HTTP from internet"
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}

# Allow inbound HTTPS

resource "aws_security_group_rule" "alb_ingress_https" {
  description       = "Allow inbound HTTPS from internet"
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}

# Allow outbound traffic to worker nodes

resource "aws_security_group_rule" "alb_egress_to_nodes" {
  description              = "Allow outbound traffic to worker nodes"
  type                     = "egress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.worker_nodes.id
  security_group_id        = aws_security_group.load_balancer.id
}

# Allow all outbound traffic (fallback)

resource "aws_security_group_rule" "alb_egress_all" {
  description       = "Allow all outbound traffic"
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.load_balancer.id
}
