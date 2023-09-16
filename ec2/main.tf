resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ami.image_id
  instance_type = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg.id]
  iam_instance_profile = "${var.env}-${var.component}-role"
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
     "ansible-pull -i localhost, -U https://github.com/shuja-git/roboshop-ansible-3 roboshop.yml -e role_name=${var.component} -e env=${var.env}"
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
resource "aws_iam_policy" "policy" {
  name        = "${var.env}-${var.component}-policy"
  path        = "/"
  description = "${var.env}-${var.component}-policy"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "ssm:GetParameterHistory",
          "ssm:GetParametersByPath",
          "ssm:GetParameters",
          "ssm:GetParameter"
        ],
        "Resource": "arn:aws:ssm:us-east-1:360589383552:parameter/${var.env}.${var.component}.*"
      },
      {
        "Sid": "VisualEditor1",
        "Effect": "Allow",
        "Action": "ssm:DescribeParameters",
        "Resource": "*"
      }
    ]
  })
}
resource "aws_iam_role" "test_role" {
  name = "${var.env}-${var.component}-role"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ec2.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
 }
resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.policy.arn
}
resource "aws_iam_instance_profile" "instance_profile" {
  name = "${var.env}-${var.component}-role"
  role = aws_iam_role.test_role.name
}