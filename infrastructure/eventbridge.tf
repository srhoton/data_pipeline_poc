resource "aws_cloudwatch_event_rule" "data_pipeline_poc_reservations_event" {
    description    = "Event rule to trigger reservations event workflow in glue"
    event_bus_name = "default"
    event_pattern  = jsonencode(
    {
      "source": ["aws.s3"],
      "detail-type": ["Object Created"],
      "detail": {
        "bucket": {
          "name": ["data-pipeline-poc-lz-bucket"]
        },
        "object": {
          "key": [{
            "prefix": "data-pipeline-poc/source_db/reservations"
          }]
        }
      }
    })
    name           = "data-pipeline-poc-reservations-event"
    tags           = {}
    tags_all       = {}
}