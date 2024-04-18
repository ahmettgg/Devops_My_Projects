



resource "aws_instance" "tf-ec2" {
  ami = data.aws_ami.amazon-linux-2023.id
  instance_type = var.instance_type
#   count = var.num_of_instance
  key_name = var.key_name
  vpc_security_group_ids = [aws_security_group.tf-sec-grp.id]
  user_data = base64encode("${file("user-data.sh")}")
  tags = {
    Name = "ahmet-bookstore"
}
}

resource "aws_security_group" "tf-sec-grp" {
    name = "bookstrore-sec-grp"
    vpc_id = data.aws_vpc.selected.id


    ingress {
        from_port = 80
        protocol = "tcp"
        to_port = 80
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port = 22
        protocol = "tcp"
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]

    }

    egress {
        from_port = 0
        protocol = -1
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
        
    }
  
}

resource "aws_route53_record" "phonebook" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "bookstore.${var.hosted-zone}"
  type    = "A"
  records = [aws_instance.tf-ec2.public_ip]
  ttl = 300
}