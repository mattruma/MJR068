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

In your Azure environment, I would recommend creating a service principal that can deploy resources to your subscription.

I am using `mjr-068` as the prefix and a suffix of the resource type, e.g. `-sp` for service principal.

Use your own naming standards.

The service principal I created was called `mjr-068-sp`.

To create the service principal run `az ad sp create-for-rbac --name SERVICE_PRINCIPAL_NAME`, replacing `SERVICE_PRINCIPAL_NAME` with the name of your service principal.

Capture the output, as you will need this information for Azure DevOps and GitHub Actions.

To deploy the infrastructure, navigate to the `/src/FunctionApp1.Infrastructure` folder and run the following script for the develop environment:

```bash
.\Deploy.ps1 -ResourcePrefix RESOURCE_PREFIX
```

## Links

[Creating an Azure Service Principal for use with an Azure Resource Manager service connection](https://azuredevopslabs.com/labs/devopsserver/azureserviceprincipal/)
