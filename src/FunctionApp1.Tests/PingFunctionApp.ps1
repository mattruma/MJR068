Param(
    [String] [Parameter(Mandatory = $true)] $FunctionUrl
)

$StatusCode = 0
$NumberOfRetries = 3
$Retries = 0
$OkStatusCode = 200
$RetryDelayInSeconds = 5

Do 
{
    Write-Host ""
    Write-Host "Pinging $($FunctionUrl)."

    $Response = (Invoke-WebRequest -URI $FunctionUrl)
    $StatusCode = $Response.StatusCode
    
    Write-Host "Responded with status code $($StatusCode)." 

    If ($StatusCode -ne $OkStatusCode) {
        $Retries = $Retries + 1
        If ($Retries -le $NumberOfRetries) {
            Write-Host "Retrying $($Retries) of $($NumberOfRetries) and sleeping for $($RetryDelayInSeconds) second(s)." 
            Start-Sleep -s $RetryDelayInSeconds
        } Else {
            Write-Host "Maximum retries exhausted."
        }
    }
}    
While ($StatusCode -ne $OkStatusCode -and $Retries -le $NumberOfRetries)

If ($StatusCode -ne $OkStatusCode) {
    Throw "Expected status code $($OkStatusCode) but received status code $($StatusCode)."
}