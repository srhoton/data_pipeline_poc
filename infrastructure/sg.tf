resource "aws_security_group" "db_subnet_group_sg" {
  name        = "db_subnet_group_sg"
  description = "Allow inbound traffic"
  vpc_id      = data.aws_vpc.dev_vpc.id
  
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [data.aws_vpc.dev_vpc.cidr_block]
  }
  
  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}