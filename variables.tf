variable "workspace_display_name" {
  description = "A name for the getting started workspace."
  type        = string
}

variable "capacity_name" {
  description = "The name of the capacity to use."
  type = string
}

variable "contributor_user_principal_id" {
  description = "The principal id of contributor (dev) user"
  type = string
}