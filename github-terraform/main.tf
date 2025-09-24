data "fabric_capacity" "capacity" {
  display_name = var.capacity_name
}

resource "fabric_connection" "github_terraform_conn" {
  display_name      = "gitterraformconn"
  connectivity_type = "ShareableCloud"
  privacy_level     = "Organizational"
  connection_details = {
    type            = "GitHubSourceControl"
    creation_method = "GitHubSourceControl.Contents"
    parameters = [
      {
        name  = "url"
        value = "https://github.com/yaronpri/fabricrepo"
      }
    ]
  }
  credential_details = {
    credential_type       = "Key"
    key_credentials       = {
      key_wo              = var.pat_sec
      key_wo_version      = 1
    }
  }
}

resource "fabric_workspace" "example_workspace" {
  display_name = var.workspace_display_name
  description = "github with Terraform"
  capacity_id = data.fabric_capacity.capacity.id
}

resource "fabric_workspace_git" "github" {
  workspace_id            = fabric_workspace.example_workspace.id
  initialization_strategy = "PreferRemote"
  git_provider_details = {
    git_provider_type = "GitHub"
    owner_name        = "yaronpri"
    repository_name   = "fabricrepo"
    branch_name       = "main"
    directory_name    = "/terraformws"
  }
  git_credentials = {
    source        = "ConfiguredConnection"
    connection_id = fabric_connection.github_terraform_conn.id
  }
}

resource "fabric_workspace_role_assignment" "example" {
  workspace_id = fabric_workspace.example_workspace.id
  principal = {
    id   = var.contributor_user_principal_id
    type = "User"
  }
  role = "Contributor"
}