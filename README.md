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

The Git repository is located at <https://github.com/mattruma/MJR068>.

The Azure DevOps project is located at <https://dev.azure.com/maruma/MJR068>.

## Links

[Creating an Azure Service Principal for use with an Azure Resource Manager service connection](https://azuredevopslabs.com/labs/devopsserver/azureserviceprincipal/)

[Azure Pipelines](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops)

[YAML schema reference](https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema)

[Feature Availability](https://docs.microsoft.com/en-us/azure/devops/pipelines/get-started/pipelines-get-started?view=azure-devops#feature-availability)