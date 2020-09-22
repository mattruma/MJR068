Param(
    [String] [Parameter(Mandatory = $true)] $FunctionUrl,
    [String] [Parameter(Mandatory = $true)] $FunctionApp1Code
)

$Content = @'
   {
   	"id": "98af05e5-b48a-4f35-88fb-38a96793a681",
   	"name": "Azure",
   	"values": [
                   {
   			"key": "FunctionUrl",
   			"value": "FUNCTION_URL",
   			"enabled": true
   		},
   		{
   			"key": "FunctionCode",
   			"value": "FUNCTION_APP_1_CODE",
   			"enabled": true
   		}
   	],
   	"_postman_variable_scope": "environment",
   	"_postman_exported_at": "2020-09-12T20:01:24.209Z",
   	"_postman_exported_using": "Postman/7.32.0"
   }
'@
  
$Content = $Content.Replace("FUNCTION_URL", $FunctionUrl)
$Content = $Content.Replace("FUNCTION_APP_1_CODE", $FunctionApp1Code)

New-Item postman_environment.json

Set-Content postman_environment.json $Content