# ---------------------------------------------------------
# DevOps Control Node
# ---------------------------------------------------------

resource "aws_instance" "devops_control" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.devops_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "QuickBite-DevOps-Control-Node"
  }
}

# ---------------------------------------------------------
# Application Server
# ---------------------------------------------------------

resource "aws_instance" "application_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public.id
  vpc_security_group_ids      = [aws_security_group.app_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = true

  tags = {
    Name = "QuickBite-Application-Server"
  }
}

# ---------------------------------------------------------
# Database Server
# ---------------------------------------------------------

resource "aws_instance" "database_server" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.private.id
  vpc_security_group_ids      = [aws_security_group.db_sg.id]
  key_name                    = var.key_name
  associate_public_ip_address = false

  tags = {
    Name = "QuickBite-Database-Server"
  }
}
