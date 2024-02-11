data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

data "aws_vpc" "dev_vpc" {
  tags = {
    Name = "dev-env-default_vpc"
  }
}

data "aws_route_table" "dev_vpc_public_subnet_route_table" {
  vpc_id = data.aws_vpc.dev_vpc.id

  tags = {
    Name = "dev-env-default_public_table"
  }
}

data "aws_subnet" "public_subnet_1" {
  vpc_id = data.aws_vpc.dev_vpc.id

  tags = {
    Name = "public-1"
  }
}

data "aws_subnet" "public_subnet_2" {
  vpc_id = data.aws_vpc.dev_vpc.id

  tags = {
    Name = "public-2"
  }
}
data "aws_subnet" "db_subnet_1" {
  vpc_id = data.aws_vpc.dev_vpc.id

  tags = {
    Name = "private-1"
  }
}

data "aws_subnet" "db_subnet_2" {
  vpc_id = data.aws_vpc.dev_vpc.id

  tags = {
    Name = "private-2"
  }
}

data "aws_subnet" "db_subnet_3" {
  vpc_id = data.aws_vpc.dev_vpc.id

  tags = {
    Name = "private-3"
  }
}






