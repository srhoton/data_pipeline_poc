resource "aws_glue_job" "source_db_test_job" {
    connections               = []
    default_arguments         = {
        "--TempDir"                          = "s3://${aws_s3_bucket.data_pipeline_poc_output_bucket.bucket}/tempdir/"
        "--enable-continuous-cloudwatch-log" = "true"
        "--enable-glue-datacatalog"          = "true"
        "--enable-job-insights"              = "false"
        "--enable-metrics"                   = "true"
        "--enable-observability-metrics"     = "true"
        "--enable-spark-ui"                  = "true"
        "--job-bookmark-option"              = "job-bookmark-enable"
        "--job-language"                     = "python"
        "--spark-event-logs-path"            = "s3://${aws_s3_bucket.data_pipeline_poc_output_bucket.bucket}/sparkHistoryLogs/"
    }
    execution_class           = "FLEX"
    glue_version              = "4.0"
    max_retries               = 0
    name                      = "source_db_test_job"
    non_overridable_arguments = {}
    number_of_workers         = 10
    role_arn                  = aws_iam_role.source_db_s3_access.arn
    tags                      = {}
    tags_all                  = {}
    timeout                   = 2880
    worker_type               = "G.1X"

    command {
        name            = "glueetl"
        python_version  = "3"
        script_location = "s3://${aws_s3_bucket.data_pipeline_script_bucket.bucket}/source_db_test_job.py"
    }

    execution_property {
        max_concurrent_runs = 1
    }
}
