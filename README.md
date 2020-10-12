# Azure Infrastructure Operations Project: Deploying a scalable IaaS web server in Azure

## Introduction
For this project, you will use a Packer template and a Terraform template to deploy a customizable, scalable web server in Azure.

## Dependencies
1. Create an [Azure Account](https://portal.azure.com) 
2. Install the [Azure command line interface](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest)
3. Install [Packer](https://www.packer.io/downloads)
4. Install [Terraform](https://www.terraform.io/downloads.html)

## Instructions
In your working directory, you should see the following files:
- server.json
- main.tf
- variables.tf
- terraform.tfvars

### Set environment variables by running the highlighted commands at the prompt
If you are not already logged in, log in to the Azure CLI using the command:

`az login`

Follow the instructions at the prompt to complete the login process.

Create a service principal and save its password as your client secret (in this case, I named my service principal *mySPName*):

`export ARM_CLIENT_SECRET=$(az ad sp create-for-rbac -n http://mySPName --query password -o tsv)`

Retrieve its id and save it as your client id

`export ARM_CLIENT_ID=$(az ad sp show --id http://mySPName --query appId -o tsv)`

Save the subscription id

`export ARM_SUBSCRIPTION_ID=$(az account show --query id -o tsv)`

Save the tenant id as an environment variable

`export TENANT_ID=$(az account show --query tenantId -o tsv)`

### Build the packer image
At the command prompt, run the command:

`packer build server.json`

### Prep for terraform, create tfvars file and add environment variable values
The file called *terraform.tfvars* in the terraform working directory should have the variables shown below:
```
TENANT_ID       = ""
SUBSCR_ID       = ""
CLIENT_ID       = ""
CLIENT_SECRET   = ""
prefix          = ""
```
Run the following commands at the command prompt to get the environment variable values:
```
echo $TENANT_ID
echo $ARM_SUBSCRIPTION_ID
echo $ARM_CLIENT_ID
echo $ARM_CLIENT_SECRET
```

Copy the returned values from the command line and insert them in the *terraform.tfvars* file. The updated file should read (feel free to update the prefix, but make sure it is 3-12 characters, lowercase letters or numbers only; I used the value **test01** as an example):
```
TENANT_ID       = "[returned value of $TENANT_ID]"
SUBSCR_ID       = "[returned value of $ARM_SUBSCRIPTION_ID]"
CLIENT_ID       = "[returned value of $ARM_CLIENT_ID]"
CLIENT_SECRET   = "[returned value of $ARM_CLIENT_SECRET]"
prefix          = "test01"
```

If you would like to update the number of virtual machines created, open the file *variables.tf* and update the *default* value for the variable **vm_count** (lines 10-13):
```
variable "vm_count" {
    description = "Number of virtual machines."
    default = 1
}
```

Alternatively, **vm_count** can be set explicitly in *terraform.tfvars* (to override the default value) by inserting the line:

`vm_count = 2`

### Initialize terraform working directory: 
**Important: If running terraform on Windows using bash, please keep the length of the full path to your .tf files as short as possible (preferably < 100 characters, not more than 256)**

At the command line, run the command:

`terraform init`

### Create the plan
At the command line, run the command:

`terraform plan -out solution.plan`

### Apply the solution plan and create the infrastructure
At the command line, run the command:

`terraform apply solution.plan`

### Output
If terraform runs with no errors and your infrastructure is genrated, the output message should end with:

```
Apply complete! Resources: 11 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

A file named *terraform.tfstate* is created in your terraform working directory

Check Azure portal for the new resource group and all of the generated infrastructure. To get destroy the infrastucture when you are done, run the command

`terraform destroy`
