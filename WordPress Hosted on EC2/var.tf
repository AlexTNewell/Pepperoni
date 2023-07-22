##################### Regions #####################

variable "primary_region" {
  description = "Primary AWS Region"
  type        = string
  default = "us-east-1a"
}

variable "secondary_region" {
  description = "Secondary AWS Region"
  type        = string
  default = "us-east-1b"
}

##################### Secrets #####################

variable "db_password" {
  type        = string
  description = "Password for the database"
}
