variable "runner_auth_token" {
  description = "The GitLab Runner registration token"
  type = string
  default = ""
}

variable "source_db_password" {
  description = "The password for the source db"
  type = string
  default = ""
  
}
