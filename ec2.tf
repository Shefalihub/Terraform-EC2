provider "aws" {
  region = "us-east-1"
}

# Fetch default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch default subnet in AZ us-east-1a
data "aws_subnet" "default_subnet" {
  availability_zone = "us-east-1a"

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Key Pair
resource "aws_key_pair" "aws_key" {
  key_name   = "aws-key"
  public_key = file("aws-key.pub")
}

# Security Group
resource "aws_security_group" "example_security" {
  name        = "allow-tls"
  description = "Allow SSH and HTTP"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "exampleSecurity"
  }
}

# EC2 Instance
resource "aws_instance" "test" {
  ami                    = var.ec2_ami_id
  instance_type          = var.ec2_instance_type
  key_name               = aws_key_pair.aws_key.key_name
  subnet_id              = data.aws_subnet.default_subnet.id
  vpc_security_group_ids = [aws_security_group.example_security.id]
  user_data              = file("nginx.sh")

  tags = {
    Name = "test-ec2"
  }

  root_block_device {
    volume_size = var.ec2_root_storage_size
    volume_type = "gp3"
  }
}
