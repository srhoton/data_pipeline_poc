resource "aws_s3_bucket" "data_pipeline_poc_bucket" {
  bucket = "data-pipeline-poc-lz-bucket"
  tags = {
    Name = "data-pipeline-poc-lz-bucket"
  }
}
resource "aws_s3_bucket_notification" "data_pipeline_poc_bucket_eb" {
  bucket = aws_s3_bucket.data_pipeline_poc_bucket.id
  eventbridge = true
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

resource "aws_s3_bucket" "data_pipeline_poc_output_bucket" {
  bucket = "data-pipeline-poc-output-bucket"
  tags = {
    Name = "data-pipeline-poc-output-bucket"
  }
}

resource "aws_s3_bucket_versioning" "data_pipeline_poc_output_bucket_versioning" {
  bucket = aws_s3_bucket.data_pipeline_poc_output_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "data_pipeline_poc_output_bucket_public_access_block" {
  bucket = aws_s3_bucket.data_pipeline_poc_output_bucket.id
  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "data_pipeline_poc_output_bucket_policy" {
  bucket = aws_s3_bucket.data_pipeline_poc_output_bucket.id
  policy = <<EOT
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:GetBucketAcl",
            "Resource":  "${aws_s3_bucket.data_pipeline_poc_output_bucket.arn}",
            "Condition": {
                "StringEquals": {
                    "AWS:SourceArn": "${aws_cloudtrail.source_db_bucket_trail.arn}"
                }
            }
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {"Service": "cloudtrail.amazonaws.com"},
            "Action": "s3:PutObject",
            "Resource": "${aws_s3_bucket.data_pipeline_poc_output_bucket.arn}/cloudtrail/AWSLogs/705740530616/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control",
                    "AWS:SourceArn": "${aws_cloudtrail.source_db_bucket_trail.arn}"
                }
            }
        }
    ]
}
EOT
}

resource "aws_s3_bucket" "data_pipeline_script_bucket" {
  bucket = "data-pipeline-poc-script-bucket"
  tags = {
    Name = "data-pipeline-poc-script-bucket"
  }
}

resource "aws_s3_bucket_versioning" "data_pipeline_poc_script_bucket_versioning" {
  bucket = aws_s3_bucket.data_pipeline_script_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "data_pipeline_poc_script_bucket_public_access_block" {
  bucket = aws_s3_bucket.data_pipeline_script_bucket.id
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