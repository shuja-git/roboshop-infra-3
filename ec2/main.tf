data "aws_caller_identity" "current" {}

data "aws_ami" "ami" {
  most_recent      = true
  name_regex       = "devops-practice-with-ansible"
  owners           = [data.aws_caller_identity.current.account_id]
}
resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = var.component
  }
}
resource "null_resource" "provisioner" {
  provisioner "remote-exec" {
    connection {
      host = aws_instance.ec2.public_ip
      user = "centos"
      password = "DevOps321"
    }
    inline = [
     "ansible-playbook -i localhost, -U https://github.com/shuja-git/roboshop-ansible-3 -e ${role_name}=${var.component}"
    ]
  }
}

resource "aws_security_group" "sg" {
  name = "${var.component}-${var.env}-sg"
description = "Allow all traffic via Terraform"

ingress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
egress {
from_port   = 0
to_port     = 0
protocol    = "-1"
cidr_blocks = ["0.0.0.0/0"]
}
}
resource "aws_route53_record" "record" {
  zone_id = "Z10218511FGAD8YC6L1HI"
  name    = "${var.component}-${var.env}.shujadevops.online"
  type    = "A"
  ttl     = 300
  records = [aws_instance.ec2.private_ip]
}
