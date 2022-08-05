provider "aws" {
  region = var.region
}

resource "aws_instance" "rjam1" {
  ami           = var.instance_ami
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}

