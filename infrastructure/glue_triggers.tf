resource "aws_glue_trigger" "data_pipeline_poc_eb_trigger" {
    enabled       = false
    name          = "data-pipeline-poc-eb-trigger"
    tags          = {}
    tags_all      = {}
    type          = "EVENT"
    workflow_name = "data-pipeline-poc-reservations-workflow"

    actions {
        arguments = {}
        job_name  = "source_db_test_job"
    }

    event_batching_condition {
        batch_size   = 1
        batch_window = 900
    }
}