##################### Regions #####################

variable "primary_region" {
  description = "Primary AWS Region"
  type        = string
  default = "us-east-1"
}

variable "secondary_region" {
  description = "Secondary AWS Region"
  type        = string
  default = "us-east-1"
}

##################### Secrets #####################

variable "db_password" {
  type        = string
  description = "Password for the database"
}