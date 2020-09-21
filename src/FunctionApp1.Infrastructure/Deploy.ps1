Param(
    [String] [Parameter(Mandatory = $true)] $ResourcePrefix,
    [String] $ResourceGroupLocation = "eastus",
    [String] $TemplateFile = "Deploy.json"
)

$ErrorActionPreference = "Stop"

$AzContext = Get-AzContext

Write-Host "Subscription              : $($AzContext.Name)"

$ResourceGroupName = "$($ResourcePrefix)-rg"
$ResourceGroup = (Get-AzResourceGroup -Name $ResourceGroupName -ErrorAction SilentlyContinue)

if ($null -eq $ResourceGroup) {
    $ResourceGroup = (New-AzResourceGroup `
        -Name $ResourceGroupName `
        -Location $ResourceGroupLocation)
}

Write-Host "Resource Group            : $($ResourceGroup.ResourceGroupName)"
Write-Host "Resource Group Location   : $($ResourceGroup.Location)"

$ServicePrincipalName = "$($ResourcePrefix)-sp"

$ServicePrincipal = Get-AzADServicePrincipal -DisplayName $ServicePrincipalName

if ($null -eq $ServicePrincipal) {    
    az ad sp create-for-rbac --name $ServicePrincipalName 

    $ServicePrincipal = Get-AzADServicePrincipal -DisplayName $ServicePrincipalName
}

New-AzResourceGroupDeployment `
    -Name ((Get-ChildItem $TemplateFile).BaseName + "-" + ((Get-Date).ToUniversalTime()).ToString("MMdd-HHmm")) `
    -ResourceGroupName $ResourceGroupName `
    -TemplateFile $TemplateFile `
    -Force `
    -Verbose `
    -resourcePrefix $ResourcePrefix `
    -userPrincipalId $ServicePrincipal.Id