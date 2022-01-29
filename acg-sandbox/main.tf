terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region                  = "us-east-1"
  shared_credentials_file = "$HOME/.aws/credentials"
  profile                 = "acg-sandbox"
}

# Create VPC
resource "aws_vpc" "my_vpc" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "tf-ec2-vpc"
  }
}

# Create VPC Subnets
resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "tf-ec2-subnet"
  }
}

#Create Network Interface
resource "aws_network_interface" "foo" {
  subnet_id   = aws_subnet.my_subnet.id
  private_ips = ["172.16.10.100"]

  tags = {
    Name = "primary_network_interface"
  }
}

# Create EC2 instances
resource "aws_instance" "tfserver-01" {
  ami           = "ami-0b0af3577fe5e3532" # us-east-1 RHEL 8
  instance_type = "t2.micro"

  tags = {
    "Name" = "tfserver-01"
  }

  network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }
}

resource "aws_instance" "tfserver-02" {
  ami           = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"

  tags = {
    "Name" = "tfserver-02"
  }
}

resource "aws_instance" "tfserver-03" {
  ami           = "ami-0b0af3577fe5e3532"
  instance_type = "t2.micro"

  tags = {
    "Name" = "tfserver-03"
  }
}