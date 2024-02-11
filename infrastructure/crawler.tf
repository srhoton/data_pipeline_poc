resource "aws_glue_crawler" "db_source_s3_crawler" {
    classifiers   = []
    configuration = jsonencode(
        {
            CreatePartitionIndex = true
            Grouping             = {
                TableLevelConfiguration = 4
            }
            Version              = 1
        }
    )
    database_name = "source-db"
    description   = "Crawler to get catalog info out of the db-source s3 bucket"
    name          = "db-source-s3-crawler"
    role          = aws_iam_role.source_db_s3_access.arn
    tags          = {
        "Name" = "db-source-s3-crawler"
    }
    tags_all      = {
        "Name" = "db-source-s3-crawler"
    }

    lake_formation_configuration {
        use_lake_formation_credentials = false
    }

    lineage_configuration {
        crawler_lineage_settings = "DISABLE"
    }

    recrawl_policy {
        recrawl_behavior = "CRAWL_EVERYTHING"
    }

    s3_target {
        exclusions  = []
        path        = "s3://data-pipeline-poc-lz-bucket/"
    }

    schema_change_policy {
        delete_behavior = "DEPRECATE_IN_DATABASE"
        update_behavior = "UPDATE_IN_DATABASE"
    }
}