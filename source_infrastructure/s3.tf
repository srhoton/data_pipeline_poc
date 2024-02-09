resource "aws_s3_bucket" "data_pipeline_poc_bucket" {
  bucket = "data-pipeline-poc-lz-bucket"
  tags = {
    Name = "data-pipeline-poc-lz-bucket"
  }
}

resource "aws_s3_bucket_versioning" "data_pipeline_poc_bucket_versioning" {
  bucket = aws_s3_bucket.data_pipeline_poc_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "data_pipeline_poc_bucket_public_access_block" {
  bucket = aws_s3_bucket.data_pipeline_poc_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_vpc_endpoint" "data_pipeline_poc_s3" {
  vpc_id = data.aws_vpc.dev_vpc.id
  service_name = "com.amazonaws.us-east-1.s3"
}

resource "aws_vpc_endpoint_route_table_association" "data_pipeline_poc_s3" {
  route_table_id = data.aws_route_table.dev_vpc_public_subnet_route_table.id
  vpc_endpoint_id = aws_vpc_endpoint.data_pipeline_poc_s3.id
}