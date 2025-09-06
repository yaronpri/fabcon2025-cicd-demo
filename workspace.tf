data "fabric_capacity" "capacity" {
  display_name = var.capacity_name
}

resource "fabric_workspace" "example_workspace" {
  display_name = var.workspace_display_name
  description = "Getting started workspace"
  capacity_id = data.fabric_capacity.capacity.id
}

resource "fabric_workspace_role_assignment" "example" {
  workspace_id = fabric_workspace.example_workspace.id
  principal = {
    id   = var.contributor_user_principal_id
    type = "User"
  }
  role = "Contributor"
}