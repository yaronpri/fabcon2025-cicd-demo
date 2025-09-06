variable "workspace_display_name" {
  description = "A name for the getting started workspace."
  type        = string
}

variable "notebook_display_name" {
  description = "A name for the subdirectory to store the notebook."
  type        = string
}

variable "notebook_definition_update_enabled" {
  description = "Whether to update the notebook definition."
  type        = bool
  default     = true
}

variable "notebook_definition_path" {
  description = "The path to the notebook's definition file."
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