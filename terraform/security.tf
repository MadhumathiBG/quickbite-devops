# ---------------------------------------------------------
# DevOps Control Node Security Group
# ---------------------------------------------------------

resource "aws_security_group" "devops_sg" {
  name        = "QuickBite-DevOps-SG"
  description = "Security group for DevOps Control Node"
  vpc_id      = aws_vpc.quickbite_vpc.id

  ingress {
    description = "SSH access"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "QuickBite-DevOps-SG"
  }
}

# ---------------------------------------------------------
# Application Server Security Group
# ---------------------------------------------------------

resource "aws_security_group" "app_sg" {
  name        = "QuickBite-Application-SG"
  description = "Security group for Application Server"
  vpc_id      = aws_vpc.quickbite_vpc.id

  ingress {
    description = "SSH from DevOps Control Node"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [
      aws_security_group.devops_sg.id
    ]
  }

  ingress {
    description = "HTTP application traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "QuickBite-Application-SG"
  }
}

# ---------------------------------------------------------
# Database Server Security Group
# ---------------------------------------------------------

resource "aws_security_group" "db_sg" {
  name        = "QuickBite-Database-SG"
  description = "Security group for MySQL Database Server"
  vpc_id      = aws_vpc.quickbite_vpc.id

  ingress {
    description     = "MySQL from Application Server only"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.app_sg.id]
  }

  egress {
    description = "Allow outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "QuickBite-Database-SG"
  }
}
