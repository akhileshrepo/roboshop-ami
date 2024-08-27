terraform {
  backend "s3" {
    bucket = "tf-roboshop-state"
    key    = "ami/terraform.tfstate"
    region = "us-east-1"
  }
}


data "aws_ami" "ami" {
  most_recent = true
  name_regex  = "Centos-8-DevOps-Practice"
  owners      = ["973714476881"]
}

resource "aws_instance" "ami" {
  ami           = data.aws_ami.ami.image_id
  vpc_security_group_ids = ["sg-0ad8ec6873fafd140"]
  instance_type = "t3.small"
  tags = {
    Name = "ami"
  }
}

resource "null_resource" "commands" {
  provisioner "remote-exec" {
    connection {
      user     = "root"
      password = "DevOps321"
      host     = aws_instance.ami.private_ip
    }

    inline = [
      "labauto ansible"
    ]
  }
}

resource "aws_ami_from_instance" "ami" {
  depends_on = [null_resource.commands]
  name               = "roboshop-ami-v1"
  source_instance_id = aws_instance.ami.id
}