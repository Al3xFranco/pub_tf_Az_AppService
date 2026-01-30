variable "name_prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "tags" { type = map(string) }

variable "subnet_id_app" { type = string }

variable "log_analytics_workspace_id" { type = string }
variable "app_insights_connection_str" { type = string }

variable "keyvault_id" { type = string }

variable "existing_secret_uri" {
  type        = string
  description = "URI of the existing KV secret"
}
