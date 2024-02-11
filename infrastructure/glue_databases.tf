resource "aws_glue_catalog_database" "source_db" {
  name = "source-db"
  description = "Catalog for source db from s3"
}

