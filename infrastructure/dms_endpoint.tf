resource "aws_dms_s3_endpoint" "data_pipeline_poc_bucket" {
  service_access_role_arn = aws_iam_role.data_pipeline_poc_s3_access.arn
  endpoint_id = "data-pipeline-poc-bucket"
  endpoint_type = "target"
  tags = {
    Name = "data_pipeline_poc_bucket"
  }
  add_column_name = "true"
  bucket_folder = "data-pipeline-poc"
  bucket_name = aws_s3_bucket.data_pipeline_poc_bucket.bucket
  cdc_inserts_and_updates = "true"
}

resource "aws_dms_endpoint" "data_pipeline_poc_source" {
  endpoint_id = "data-pipeline-poc-source"
  endpoint_type = "source"
  engine_name   = "aurora"
  username      = "root"
  password      = "${var.source_db_password}"
  database_name = "source_db"
  port = "3306"
  server_name = aws_rds_cluster.source_db.endpoint
  
}
