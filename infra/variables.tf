variable "domain_name" {
  description = "Domain name for the sample app"
  type        = string
  default     = "eko.dev"
}
variable "hosted_zone_id" {
  description = "Hosted zone id"
  type = string
  default = "Z0656305131OZSNUKVN21"
}

variable "deploy_db_primary" {
  description = "Deploy RDS MySQL"
  type = bool
  default = true
}

variable "deploy_db_secondary" {
  description = "Deploy RDS MySQL"
  type = bool
  default = false
}