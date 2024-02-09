resource "aws_db_subnet_group" "source_subnet_group" {
  description = "subnet group for source db"
  subnet_ids = [ data.aws_subnet.db_subnet_1.id, data.aws_subnet.db_subnet_2.id, data.aws_subnet.db_subnet_3.id ]
  tags = {
    Name = "source-db-subnet-group"
  }
}

resource "aws_rds_cluster" "source_db" {
  cluster_identifier = "source-db"
  engine = "aurora-mysql"
  #engine_mode = "serverless"
  engine_version = "5.7.mysql_aurora.2.11.4"
  database_name = "source_db"
  master_username = "root"
  master_password = var.source_db_password
  backup_retention_period = 1
  preferred_backup_window = "07:00-09:00"
  preferred_maintenance_window = "sun:23:00-mon:01:00"
  db_subnet_group_name = aws_db_subnet_group.source_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_subnet_group_sg.id] 
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.source_db.name
  #scaling_configuration {
  #  auto_pause = true
  #  max_capacity = 2
  #  min_capacity = 1
  #  seconds_until_auto_pause = 300
  #}
  tags = {
    Name = "source-db"
  }
}

resource "aws_rds_cluster_instance" "source_db" {
  identifier = "source-db"
  cluster_identifier = aws_rds_cluster.source_db.id
  instance_class = "db.t3.large"
  engine = aws_rds_cluster.source_db.engine
  engine_version = aws_rds_cluster.source_db.engine_version
}

resource "aws_rds_cluster_parameter_group" "source_db" {
  name = "source-db-parameter-group"
  family = "aurora-mysql5.7"


  parameter {
    name = "binlog_format"
    value = "ROW"
    apply_method = "pending-reboot"
  }
}