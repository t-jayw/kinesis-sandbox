resource "aws_instance" "app_server" {
  ami           = "ami-0b0ea68c435eb488d"
  instance_type = "t2.micro"
  count = 1
  subnet_id = aws_subnet.subnet-uno.id
  key_name = aws_key_pair.key121.key_name
  security_groups = [aws_security_group.ingress-all-test.id] 


  connection {
    type        = "ssh"
    user        = "asdf"
    private_key = tls_private_key.oskey.private_key_pem
    host        = aws_instance.app_server[0].public_ip
  }

  tags = {
    Name = "test-ec2-micro"
  }
}
