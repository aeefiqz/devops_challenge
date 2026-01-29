# Security Group for EKS Cluster
resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "Security group for EKS cluster control plane"
  vpc_id      = aws_vpc.eks_vpc.id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

 tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-cluster-sg"
      Environment = var.environment
    })
}

# Security Group for EKS Node Group
resource "aws_security_group" "eks_node_sg" {
  name        = "${var.cluster_name}-node-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc.id

  # Allow nodes to communicate with each other
  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
    description = "Node to node communication"
  }

  # Allow worker nodes to receive traffic from cluster control plane
  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
    description     = "Cluster control plane to node group communication"
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "All outbound traffic"
  }

  tags = merge(
    var.tags,
    {
      Name        = "${var.environment}-node-sg"
      Environment = var.environment
    })
}

# Allow cluster control plane to communicate with worker nodes
resource "aws_security_group_rule" "cluster_to_node" {
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.eks_node_sg.id
  security_group_id        = aws_security_group.eks_cluster_sg.id
  description              = "Cluster control plane to node group (HTTPS)"
}