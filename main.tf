data "fabric_capacity" "capacity" {
  display_name = var.capacity_name
}

resource "fabric_connection" "ado_terraform_conn" {
  display_name      = "adoterraformconn"
  connectivity_type = "ShareableCloud"
  privacy_level     = "Organizational"
  connection_details = {
    type            = "AzureDevOpsSourceControl"
    creation_method = "AzureDevOpsSourceControl.Contents"
    parameters = [
      {
        name  = "url"
        value = "https://dev.azure.com/fabriccicd020725/Fabric/_git/fabric1/"
      }
    ]
  }
  credential_details = {
    credential_type       = "ServicePrincipal"
    skip_test_connection  = false
    service_principal_credentials = {
      client_id           = var.client_id
      client_secret_wo    = var.client_secret
      client_secret_wo_version = 1
      tenant_id           = var.tenant_id
    }
  }
}

resource "fabric_workspace" "example_workspace" {
  display_name = var.workspace_display_name
  description = "Getting started workspace"
  capacity_id = data.fabric_capacity.capacity.id
}

resource "fabric_workspace_git" "azdo" {
  workspace_id            = fabric_workspace.example_workspace.id
  initialization_strategy = "PreferRemote"
  git_provider_details = {
    git_provider_type = "AzureDevOps"
    organization_name = "fabriccicd020725"
    project_name      = "Fabric"
    repository_name   = "fabric1"
    branch_name       = "main"
    directory_name    = "/"
  }
  git_credentials = {
    source        = "ConfiguredConnection"
    connection_id = fabric_connection.ado_terraform_conn.id
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