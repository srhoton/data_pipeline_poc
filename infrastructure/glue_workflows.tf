resource "aws_glue_workflow" "data_pipeline_poc_reservations_workflow" {
    description            = "Workflow to trigger reservations job"
    max_concurrent_runs    = 0
    name                   = "data-pipeline-poc-reservations-workflow"
}