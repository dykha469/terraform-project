#Configuration VPC dev
resource "aws_vpc" "dev_vpc" {
provider = aws.dev
    cidr_block = "10.3.0.0/16"

    tags = {
    Name = "dev_vpc"
  } 
}
#Configuration subnet
resource "aws_subnet" "public_subnetdev" {
    provider = aws.dev
  vpc_id = aws_vpc.dev_vpc.id
  cidr_block = "10.3.0.0/24"
  availability_zone = var.subpub_dev
  tags = {
    Name="public_subnetdev"
  } 
}
#Config internet gateway comptedev
resource "aws_internet_gateway" "igw-comptedev" {
    provider = aws.dev
 vpc_id = aws_vpc.dev_vpc.id
 tags = {"Name" = "igw-compteDev" }
}
#Config table de routage logarchive
resource "aws_route_table" "table_pub_comptedev" {
    provider = aws.dev
 vpc_id = aws_vpc.dev_vpc.id
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw-comptedev.id
 } 
 tags = { "Name" = "table_pub_comptedev"}
}
#Association table de routage au sous réseau pub
resource "aws_route_table_association" "table_pub_comptedev" {
    provider = aws.dev
 subnet_id = aws_subnet.public_subnetdev.id
 route_table_id = aws_route_table.table_pub_comptedev.id
}
#configuration groupe de sécurité
resource "aws_security_group" "groupedesecurite" {
    provider = aws.dev
    vpc_id = aws_vpc.dev_vpc.id
  name        = "securitygroup_traffic"
  description = "Autoriser trafic HTTP, HTTPS  et SSH entrant"
  

  # Autoriser les requêtes HTTP entrantes
  ingress {
   description = "HTTP"
   from_port   = 80
   to_port     = 80
   protocol    = "tcp"
   cidr_blocks = ["0.0.0.0/0"] 
  }

  # Autoriser les requêtes HTTPS entrantes 
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
 # Autoriser ssh
  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
   egress {
    from_port = 0    
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "securitygroup"
  }
}