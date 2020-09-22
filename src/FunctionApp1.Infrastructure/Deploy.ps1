Param(
    [String] [Parameter(Mandatory = $true)] $ResourcePrefix,
    [String] $ResourceGroupLocation = "eastus",
    [String] [Parameter(Mandatory = $true)] $ServicePrincipalName,
    [String] $TemplateFile = "Deploy.json"
)

$ErrorActionPreference = "Stop"

$AzContext = Get-AzContext

Write-Host "Subscription            : $($AzContext.Name)"

$ServicePrincipal = Get-AzADServicePrincipal -DisplayName $ServicePrincipalName

If ($null -eq $ServicePrincipal) { 
    throw "The service principal $($ServicePrincipalName) does not exist."
}

Write-Host "Service Principal Id    : $($ServicePrincipal.Id)"

$ResourceGroupName = "$($ResourcePrefix)-rg"
$ResourceGroup = (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)

If ($null -eq $ResourceGroup) {
    $ResourceGroup = (New-AzResourceGroup `
        -Name $ResourceGroupName `
        -Location $ResourceGroupLocation)
}

Write-Host "Resource Group          : $($ResourceGroup.ResourceGroupName)"
Write-Host "Resource Group Location : $($ResourceGroup.Location)"

New-AzResourceGroupDeployment `
    -Name ((Get-ChildItem $TemplateFile).BaseName + "-" + ((Get-Date).ToUniversalTime()).ToString("MMdd-HHmm")) `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -Force `
    -Verbose `
    -resourcePrefix $ResourcePrefix `
    -servicePrincipalId $ServicePrincipal.Id