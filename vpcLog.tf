
 #Configuration VPC logArchive
resource "aws_vpc" "logArchive_vpc" {
provider = aws.log
    cidr_block = "10.2.0.0/16"
    tags = {
    Name = "logArchive_vpc"
  } 
}
#Configuration subnet
resource "aws_subnet" "public_subnetlog" {
    provider = aws.log
  vpc_id = aws_vpc.logArchive_vpc.id
  cidr_block = "10.2.0.0/24"
  availability_zone = var.subpub_log
  tags = {
    Name="public_subnetlog"
  } 
}
#Config internet gateway logarchive
resource "aws_internet_gateway" "igw-compteArchive" {
    provider = aws.log
 vpc_id = aws_vpc.logArchive_vpc.id
 tags = {"Name" = "igw-compteArchive" }
}
#Config table de routage logarchive
resource "aws_route_table" "table_pub_compteArchive" {
    provider = aws.log
 vpc_id = aws_vpc.logArchive_vpc.id
 route {
 cidr_block = "0.0.0.0/0"
 gateway_id = aws_internet_gateway.igw-compteArchive.id
 } 
 tags = { "Name" = "table_pub_compteArchive"}
}
#Association table de routage au sous réseau pub
resource "aws_route_table_association" "table_pub_compteArchive" {
    provider = aws.log
 subnet_id = aws_subnet.public_subnetlog.id
 route_table_id = aws_route_table.table_pub_compteArchive.id
}








