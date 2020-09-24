# Introduction

Notes for successfully running the demo.

## Azure

Navigate to <https://ms.portal.azure.com/#@microsoft.onmicrosoft.com/resource/subscriptions/2164386e-942c-4314-b71e-d4dc327856c5/resourceGroups/mjr-068-dev-rg/overview>

* Resource Group for each environment: `dev`, `stg` and `prd`.
* Function App
  * Application Insights
  * Storage Account
  * App Service Plan (Consumption)
* Storage Account
* Key Vault

## Project

Navigate to <https://github.com/mattruma/MJR068>.

Navigate to <https://github.com/mattruma/MJR068/tree/master/src>.

This project imports a list of my board games from the BoardGameGeek JSON API at <https://bgg-json.azurewebsites.net> into Azure Blob Storage.

An endpoint is then provided to retrieve the data from Azure Blob Storage and return the results at JSON.

Secrets will be stored in Key Vault, e.g. the code for Function App and the Connection String for Azure Blob Storage.

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

Start with the classic interface, little more graphical when it comes to the steps and the overall flow.

Made of (2) pipelines, a build and release.

The **build pipeline** builds the Azure Function and includes the files to deploy the infrastructure and run the Postman integration tests.

The **release pipeline** deploys the infrastructure and code to Azure and then executes the Postman integration tests.

### Build Pipeline

1. Navigate to <https://dev.azure.com/maruma/MJR068/_build>.
2. Click **FunctionApp-classic-build**.
3. Click **Edit**.
4. Review **Tasks**, including Get sources, Build job, Restore, Build, Copy deployment files, Copy integration test files, Publish and Publish Artifact.
5. Review **Triggers**.
    1. Check the **Enable continuous integration** check box.
6. Review **Variables**, **Options**, **Retention** and **History**.
7. Navigate back to the builds at <https://dev.azure.com/maruma/MJR068/_build?definitionId=41>.
8. Click **Run pipeline**, should take less than 60 seconds to run.

### Release pipeline

The release pipeline is setup to auto deploy to the **Develop** environment and then is gated for approval for both the **Staging** and **Production** environment.

1. Navigate to <https://dev.azure.com/maruma/MJR068/_release?_a=releases&view=mine&definitionId=1>.
2. A release should be running for our **Develop** environment.
3. Click **Edit**.
4. Review **Artifacts**.
   1. Using the build artifact from our previous step.
   2. Originally, included a second artifact for the GitHub repository so the files could be accessed from the repository, but opted to include them instead with build artifact.
   3. Triggers on a successful build, could also have it execute on a pull request.
5. Review **Variables**
   1. Different for each environment.
   2. What about secrets? Those come straight from Key Vault, we will see this in the Tasks.
6. Review **Tasks**.
   1. Review **Deploy infrastructure**.
        1. Navigate to <https://github.com/mattruma/MJR068/tree/master/src/FunctionApp1.Infrastructure>.
        2. Review `Deploy.ps1` and `Deploy.json`.
        3. Variables are substituted for script parameters.
   2. Review **Deploy code**.
        1. The `StorageConnectionString` is pulled from Key Vault.
   3. Review **Run integration tests**.
        1. Dynamically creating the file for the Postman environment, injecting secrets from Key Vault for the Function App code.
        2. Could combine command line steps, might improve performance, but a little more readable this way.
7. Review **Retention**, **Options** and **History**.

8. Show Approvals for the `Staging` and `Production` environments.

9. Navigate to <https://dev.azure.com/maruma/MJR068/_releaseProgress?_a=release-pipeline-progress&releaseId=23> and look at a successful run.

    1. Variables are limited to the run <https://dev.azure.com/maruma/MJR068/_releaseProgress?releaseId=23&environmentId=39&_a=release-environment-variables>.
    2. Log details <https://dev.azure.com/maruma/MJR068/_releaseProgress?releaseId=23&environmentId=39&_a=release-environment-logs>
    3. Test results <https://dev.azure.com/maruma/MJR068/_releaseProgress?_a=release-environment-extension&releaseId=23&environmentId=39&extensionId=ms.vss-test-web.test-result-in-release-environment-editor-tab>

10. Disable continous integration at <https://dev.azure.com/maruma/MJR068/_apps/hub/ms.vss-ciworkflow.build-ci-hub?_a=edit-build-definition&id=41&view=Tab_Triggers> before demo of YAML syntax.

## Define pipelines using YAML syntax

What does this look like in YAML?

See <https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema> for details on YAML schema.

Our YAML pipeline will include BOTH the build and release pipelines of our previous step.

1. To bring in variables we will need to make use of **Variable Groups** at <https://dev.azure.com/maruma/MJR068/_library?itemType=VariableGroups>.
    1. This is how we link to Key Vault.
2. To have approval gates for `Staging` and `Production` we will need to make use of **Environments** at <https://dev.azure.com/maruma/MJR068/_environments>.
3. Navigate to the YAML file at <https://github.com/mattruma/MJR068/blob/master/src/FunctionApp1/azure-pipelines.yml>.
    1. Starts with **Triggers** <https://docs.microsoft.com/en-us/azure/devops/pipelines/yaml-schema?view=azure-devops&tabs=schema%2Cparameter-schema#triggers>  
    2. Consists if **Stages**, **Jobs** and **Steps**.
        1. Steps are made of Tasks that execute sequentially.
    3. Stages are `Build`, `Develop`, `Staging` and `Production`.
    4. When looking at the `Develop` stage point out the following:
        1. **Variable Groups** are pulled in and secrets are downloaded from Key Vault by assigning the variable group to the `group` property of the `variable` property for the **Job**.
        2. **Stages** and **Jobs** can include a `dependsOn` to control when the **Stage** or **Job** will execute.
        3. For code deployment we are using a deployment job which allows for an `environment` to be assigned, which will allow for the approval gating.
    5. Sometimes the Function App is not available when the integration tests run, so there is another step that runs a PowerShell script to verify the Function App is available, see <https://github.com/mattruma/MJR068/blob/master/src/FunctionApp1.Tests/PingFunctionApp.ps1>.
    6. The `Develop` job is duplicated for the `Staging` and `Production` jobs BUT this could be simplified using Templates.
        1. <https://jpearson.blog/2019/10/01/using-templates-in-yaml-pipelines-in-azure-devops/>
        2. <https://docs.microsoft.com/en-us/azure/devops/pipelines/process/templates?view=azure-devops>
    7. Navigate to the pipeline at <https://dev.azure.com/maruma/MJR068/_build?definitionId=42&_a=summary>.
        1. Show how you can see the length each step ran, this can help streamline the pipeline.
    8. Change the trigger from `master` branch to `none`, because we are moving on to GitHub Actions.

## Run a workflow with GitHub Actions

## Questions

How do I not trigger on certain files or trigger on certain files?

