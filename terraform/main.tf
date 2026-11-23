terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Fetch latest Amazon Linux 2023 AMI without hardcoding AMI IDs
data "aws_ami" "al2023" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-2023*-x86_64"]
  }
}

# Generate SSH Key Pair in state (avoids local_file Windows lock errors)
resource "tls_private_key" "demo_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = "${var.student_prefix}-drift-key"
  public_key = tls_private_key.demo_key.public_key_openssh
}

# Security Group whose ingress rules we will intentionally break in the AWS Console
resource "aws_security_group" "web_sg" {
  name        = "${var.student_prefix}-drift-sg"
  description = "Managed by Terraform - Drift Detection Demo"

  ingress {
    description = "HTTP Traffic"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Restricted SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.allowed_ssh_cidr]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.student_prefix}-drift-sg"
    ManagedBy = "Terraform"
  }
}

resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.al2023.id
  instance_type          = "t3.micro"
  key_name               = aws_key_pair.generated_key.key_name
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name      = "${var.student_prefix}-drift-web"
    ManagedBy = "Terraform"
  }
}
