terraform {
  backend "s3" {
    bucket = "b2c-tfstate"
    key    = "rhoton/data_pipeline_source.tfstate"
    region = "us-west-2"
  }
}
