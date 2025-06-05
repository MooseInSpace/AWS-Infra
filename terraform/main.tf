terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.42.0"
    }
  }
}

# Defining Region for creation "us-east-1" under the "AWS" provider
provider "aws" {
  region = var.region
}

# Defining VPC for creation
/*resource "aws_vpc" "main"{
  cidr_block = "10.0.1.0/24"
  id = "vpc-0804cecbf3cc99e14"

  tags = {
    Name = "vpc-Enshrouded" 
  }
}
*/

# Only for Initial Subnet creation
/*resource "aws_subnet" "public_subnets" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr, count.index)

  tags = {
    Name = "Public Subnet ${count.index + 1}"
  }
}
*/

/*resource "aws_subnet" "private_subnets" {
  count = length(var.public_subnets_cidr)
  vpc_id = aws_vpc.main.id
  cidr_block = element(var.public_subnet_cidr, count.index)
}
*/

/*resource "aws_security_group" "enshrouded_server_sg" {
  name = "enshrouded-server-sg"
  description = "Allows HTTPS/15636 UDP Game Traffic to/from server"
  vpc_id = aws_vpc.main.id

  ingress {
    description = "Allow ONLY 15636 UDP inbound rule"
    from_port = 15636
    to_port = 15636
    protocol = "UDP"
    cidr_block = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ONLY DNS Traffic outbound for Hostname resolution"
    from_port = 53
    to_port = 53
    protocol = "UDP"
    cidr_block = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ONLY HTTP Traffic outbound for updates"
    from_port = 80
    to_port = 80
    protocol = "TCP"
    cidr_block = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow ONLY HTTPS Traffic outbound for updates"
    from_port = 443
    to_port = 443
    protocol = "TCP"
    cidr_block = ["0.0.0.0/0"]
  }
}
*/

# Defining ec2 instance for creation
resource "aws_instance" "enshrouded-server" {
  ami           = "ami-0f9de6e2d2f067fca" # Ubuntu 22.04 AMI, Overwritten by launch template
  instance_type = "t2.micro"

  launch_template {
    id = "lt-0932972b24c9e9230"
    version = "$Latest"
  }

  lifecycle {
    ignore_changes = [ami]
  }

  iam_instance_profile = "EC2-SSM-InstanceRole" # Allows SSM access to EC2 Instance
}

output "instance_ip" {
  value = aws_instance.enshrouded-server.public_ip  # Grabs the public IP from the created EC2
}

output "instance_id" {
  value = aws_instance.enshrouded-server.id # Grabs the instance ID for Ansible SSM connection
}