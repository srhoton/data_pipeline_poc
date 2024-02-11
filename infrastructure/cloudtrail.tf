resource "aws_cloudtrail" "source_db_bucket_trail" {
    enable_log_file_validation    = true
    enable_logging                = true
    include_global_service_events = true
    is_multi_region_trail         = true
    is_organization_trail         = false
    name                          = "source-db-bucket-trail"
    s3_bucket_name                = aws_s3_bucket.data_pipeline_poc_output_bucket.bucket
    s3_key_prefix                 = "cloudtrail"
    tags                          = {}
    tags_all                      = {}

    advanced_event_selector {
        field_selector {
            equals          = [
                "AWS::S3::Object",
            ]
            field           = "resources.type"
        }
        field_selector {
            equals          = [
                "Data",
            ]
            field           = "eventCategory"
        }
        field_selector {
            equals          = [
                "false",
            ]
            field           = "readOnly"
        }
    }
}