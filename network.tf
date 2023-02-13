resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true
  tags =  {
    Name = "test-env"
  }
}

resource "aws_subnet" "subnet-uno" {
  cidr_block = "${cidrsubnet(aws_vpc.test-env.cidr_block, 4, 1)}"
  vpc_id = "${aws_vpc.test-env.id}"
  availability_zone = "us-east-1a"
}

//security.tf
resource "aws_security_group" "ingress-all-test" {
name = "allow-all-sg"
vpc_id = "${aws_vpc.test-env.id}"
ingress {
    cidr_blocks = [
      "0.0.0.0/0"
    ]
from_port = 22
    to_port = 22
    protocol = "tcp"
  }
// Terraform removes the default rule
  egress {
   from_port = 0
   to_port = 0
   protocol = "-1"
   cidr_blocks = ["0.0.0.0/0"]
 }
}

resource "aws_eip" "ip-test-env" {
  instance = "${aws_instance.app_server[0].id}"
  vpc      = true
}

//gateways.tf
resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = "${aws_vpc.test-env.id}"
  tags = {
    Name = "test-env-gw"
  }
}

//route_table.tf
resource "aws_route_table" "route-table-test-env" {
  vpc_id = "${aws_vpc.test-env.id}"
route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.test-env-gw.id}"
  }
tags =  {
    Name = "test-env-route-table"
  }
}

resource "aws_route_table_association" "subnet-association" {
  subnet_id      = "${aws_subnet.subnet-uno.id}"
  route_table_id = "${aws_route_table.route-table-test-env.id}"
}


# Key
resource "tls_private_key" "oskey" {
  algorithm = "RSA"
}

resource "local_file" "myterrakey" {
  content  = tls_private_key.oskey.private_key_pem
  filename = "myterrakey.pem"
}

resource "aws_key_pair" "key121" {
  key_name   = "myterrakey"
  public_key = tls_private_key.oskey.public_key_openssh
}
