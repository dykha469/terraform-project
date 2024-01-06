#configuration instance EC2
resource "aws_instance" "instance" {
    provider = aws.dev
  ami = "ami-05fb0b8c1424f266b" 
  instance_type = "t2.micro"

  # subnet
  subnet_id = aws_subnet.public_subnetdev.id
  # Security group pour autoriser SSH
  security_groups = [aws_security_group.groupedesecurite.id]

  tags = {
    Name = "mon_instance"
  }
  key_name = aws_key_pair.ma_cle.key_name
  associate_public_ip_address = true
  iam_instance_profile = aws_iam_instance_profile.ec2_instance_profile.name
}
output "dns_name" {
  value = aws_instance.instance.public_dns 
}
#generer une paire de clé ssh
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
#Enregistrer la clé publique sur AWS
resource "aws_key_pair" "ma_cle" {
  key_name   = "key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}
#Enregistrer la clé privée localement
resource "local_file" "clé_privée" {
  content = tls_private_key.ssh_key.private_key_pem
  filename = "keyprivee.pem"
}
#Creer un role iam pour l'instance
resource "aws_iam_role" "ec2_instance_role" {
  provider = aws.dev
   name = "ec2_instance_connect"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Principal = {
        Service = "ec2.amazonaws.com"
      },
      Action    = "sts:AssumeRole"
    }]
  })
}
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  provider = aws.dev
  name = "ec2_instance_profile"
  role = aws_iam_role.ec2_instance_role.name
}
