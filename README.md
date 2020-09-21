# Introduction

This project demonstrates building CI/CD using [Azure pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/what-is-azure-pipelines?view=azure-devops), first with the [classic interface](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops#define-pipelines-using-the-classic-interface) to build a build and release pipeline, second using a [YAML syntax](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops#define-pipelines-using-yaml-syntax), and lastly using [GitHub Actions](https://docs.github.com/en/actions).

The project imports the user's board game collection and provides and endpoint to retrieve the list.

The project consists of an Azure Function App with two functions:

* GameImportHttpTrigger - Adds or removes games.
* GameImportTimerTrigger - Adds or removes games.
* GameListHttpTrigger - Returns a list of games.

The data will be stored in an Azure Storage.

## Getting started

This project makes use of [trunk based development](https://trunkbaseddevelopment.com/).

This project makes use of three environments: develop, staging and production.

The project includes integration tests using a Postman collection.

In the Azure environment, create (3) service principals for each of the environment.

For my project, I am using `mjr-068` as the prefix and a suffix of the resource type, e.g. `-sp` for service principal.

Use your own naming standards.

The (3) service principals I created are as follows:

* Develop `mjr-068-dev-sp`
* Staging `mjr-068-stg-sp`
* Production `mjr-068-prd-sp`

The following steps involve running Azure cli or PowerShell scripts from the command line, this can be accomplished from your favorite Terminal utility.

To create the service principals run `az ad sp create-for-rbac --name SERVICE_PRINCIPAL_NAME`, replacing `SERVICE_PRINCIPAL_NAME` with the name of the service principal for each environment.

Capture the output for each, as you will need this information for future steps.

To deploy the infrastructure, navigate to the src/FunctionApp1.Infrastructure folder and run the following script for the develop environment:

```bash
.\Deploy.ps1 -ResourcePrefix RESOURCE_PREFIX -UserPrincipalId USER_PRINCIPAL_ID
```

USER_PRINCIPAL_ID should be your Id, or the Id of the context your are running the scripts in, and can be found by running `Get-AzADUser -UserPrincipalName (Get-AzContext).Account.Id`.

## Links

[Creating an Azure Service Principal for use with an Azure Resource Manager service connection](https://azuredevopslabs.com/labs/devopsserver/azureserviceprincipal/)
