# Introduction

Notes for successfully running the demo.

## Project

Navigate to <https://github.com/mattruma/MJR068>.

Navigate to <https://github.com/mattruma/MJR068/tree/master/src>.

This project imports a list of my board games from the BoardGameGeek JSON API at <https://bgg-json.azurewebsites.net> into Azure Blob Storage.

An endpoint is then provided to retrieve the data from Azure Blob Storage and return the results at JSON.

### FunctionApp1

Contains (3) functions.

**GameImportHttpTrigger** - Retrieves a list of games from the BoardGameGeek JSON API and saves it to Azure Blob Storage.

**GameImportTimerTrigger** - Performs the same function as the GameImportHttpTrigger but runs automatically at 10:00 PM each night.

**GameListHttpTrigger** - Retrieves the data from Azure Blob Storage and returns a list of games.

### FunctionApp1.Infrastructure

Contains the ARM template, `Deploy.json`, and PowerShell script, `Deploy.ps1` to build out the Azure environment.

### FunctionApp1.Tests

Contains the Postman collection for the integration tests.

The `RunIntegrationTests_CreateParametersFile.ps` creates the parameters file for the Postman collection, pulling in the Function App Code from Key Vault.

The `PingFunctionApp.ps1` attempts to hit the Function App to ensure it is up and running, in some cases, on the first deployment or a slow restart, it takes a few seconds for the Function App to come back online.

## Define pipelines using the Classic interface

1. Navigate to <https://dev.azure.com/maruma/MJR068/_build?definitionId=41>.

2. Click **Edit**.

3. Click **Trigger**.

4. Check the **Enable continuous integration** check box.

## Define pipelines using YAML syntax

## Run a workflow with GitHub Actions

## Questions

How do I not trigger on certain files or trigger on certain files?

