resource "aws_security_group" "db_source_bastion_inbound" {
  name = "db_source_bastion_inbound"
  vpc_id = data.aws_vpc.dev_vpc.id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0 
    protocol = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "db_source_bastion_inbound"
  }
}

resource "aws_instance" "bastion_instance" {
  ami = "ami-053b0d53c279acc90"
  instance_type = "m5.large"
  associate_public_ip_address = true

  subnet_id = data.aws_subnet.public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.db_source_bastion_inbound.id]
  key_name = "b2c"

  tags = {
    Name = "db_source_bastion"
  }
}
