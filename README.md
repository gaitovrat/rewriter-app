# rewriter-app
This app rewrites text using OpenAI API.

## Infrastructure setup
1. Install [direnv](https://direnv.net/) and [Terraform](https://developer.hashicorp.com/terraform/tutorials/azure-get-started/install-cli).
2. Create a resource group in Azure (you can use Azure Portal or Azure CLI).
3. Copy `terraform/.envrc.tmpl` to `terraform/.envrc` and update the variables with your values.
4. Run `direnv allow` in the `terraform`
5. Create `terraform/variables/project.backend.tfvars` file with the following content:
   ```hcl
   resource_group_name  = "<your-resource-group-name>"
   storage_account_name = "<your-storage-account-name>"
   ```
6. Execute the following commands in the `terraform` directory:
   ```bash
   terraform init -backend-config=variables/project.backend.tfvars
   terraform apply -var-file=variables/project.tfvars
   ```

### .envrc description
|Environment Variable|Description|
|---|---|
|`TF_VAR_resource_group_name`|Name of the resource group where resources will be created|
|`ARM_SUBSCRIPTION_ID`|Azure Subscription ID|

### project.backend.tfvars description
|Variable|Description|
|---|---|
|`resource_group_name`|Name of the resource group where the Terraform state storage account is located|
|`storage_account_name`|Name of the storage account where the Terraform state file will be stored|

## Application setup
1. Install [direnv](https://direnv.net/) and [uv](https://docs.astral.sh/uv/)
1. Copy `app/.envrc.tmpl` to `app/.envrc` and
2. Update the variables with your values.
3. Run `direnv allow` in the `app` directory.
4. Run `uv sync --locked` to install the dependencies.
5. Start the application with `uv run fastapi main.py`.

### .envrc description
|Environment Variable|Description|
|---|---|
|`AZURE_API_ENDPOINT`|Your Azure OpenAI endpoint (e.g., `https://<your-resource-name>.openai.azure.com/`)|
|`AZURE_API_KEY`|Your Azure OpenAI API key|
|`AZURE_API_VERSION`|API version to use (e.g., `2024-02-15-preview`)|
|`AZURE_DEPLOYMENT`|The name of the deployment you want to use (e.g., `gpt-4o-mini`)|
