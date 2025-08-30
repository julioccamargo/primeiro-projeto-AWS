
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "sa-east-1"
}
resource "tls_private_key" "rsa_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "ec2_key" {
  key_name   = "ec2-key-terraform" # Nome que aparecerá no painel da AWS
  public_key = tls_private_key.rsa_key.public_key_openssh
}
resource "local_file" "private_key_pem" {
  content  = tls_private_key.rsa_key.private_key_pem
  filename = "ec2-key-terraform.pem"
  file_permission = "0400"
}
resource "aws_security_group" "web_server_sg" {
  name        = "web-server-sg-terraform"
  description = "Permite acesso HTTP e SSH"


  ingress {
    description      = "HTTP do mundo todo"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] # "0.0.0.0/0" significa "de qualquer IP"
  }


  ingress {
    description      = "SSH do mundo todo"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" # "-1" significa "qualquer protocolo"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "SG Servidor Web (Terraform)"
  }
}

resource "aws_instance" "web_server" {

  ami           = "ami-02556f6726aa38019" 
  instance_type = "t3.micro"
  vpc_security_group_ids = [aws_security_group.web_server_sg.id]
  key_name = aws_key_pair.ec2_key.key_name

  tags = {
    Name = "Servidor Web (Criado com Terraform)"
  }
}

output "instance_public_ip" {
  description = "O endereço IP publico da nossa instancia EC2."
  value       = aws_instance.web_server.public_ip
}
