data "aws_ami" "amazon-linux-2023" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name = "architecture"
    values = ["x86_64"]
  }

  filter {
    name = "name"
    values = ["al2023-ami-2023*"]
  }

}

data "aws_vpc" "selected" {
  default = true
}

data "aws_route53_zone" "selected" {
  name         = var.hosted-zone
}