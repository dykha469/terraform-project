terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.29.0"
      
    }
  }
}
# Configuration provider compte maitre
provider "aws" {
  region = "us-east-1"
  access_key = "AKIAQIMZPXEFF2UVBX4A"
  secret_key = "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"
}
# Configuration provider compte Archive de journaux
provider "aws" {
  assume_role {
   role_arn = "arn:aws:iam::894522627426:role/AssumeRole1"
  }
 region  = var.region_log
 alias = "log"
}
# Configuration provider compte dév
provider "aws" {
  assume_role {
   role_arn = "arn:aws:iam::224078010398:role/AssumeRole"
  }
 region  = var.region_dev
 alias = "dev"
}

 #Configuration VPC1
resource "aws_vpc" "comptegestion_vpc" {
    cidr_block = "10.1.0.0/16"
    tags = {
    Name = "comptegestion_vpc"
  }
  
}

resource "aws_subnet" "public_subnetkhady" {
  vpc_id = aws_vpc.comptegestion_vpc.id
  cidr_block = "10.1.0.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name="public_subnetkhady"
  } 
}
resource "aws_subnet" "private_subnetkhady" {
  vpc_id = aws_vpc.comptegestion_vpc.id
  cidr_block = "10.1.1.0/24"
  availability_zone = "us-east-1a"
  tags = {
    Name="private_subnetkhady"
  } 
}




resource "aws_internet_gateway" "igw-comptegestion" {
 vpc_id = aws_vpc.comptegestion_vpc.id
 tags = {"Name" = "igw-comptegestion" }
}
resource "aws_route_table" "table_pub_comptegestion" {
 vpc_id = aws_vpc.comptegestion_vpc.id
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw-comptegestion.id
 } 
 tags = { "Name" = "table_pub_comptegestion"}
}

resource "aws_route_table_association" "table_pub_comptegestion" {
 subnet_id = aws_subnet.public_subnetkhady.id
 route_table_id = aws_route_table.table_pub_comptegestion.id
}


