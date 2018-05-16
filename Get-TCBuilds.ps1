# Query teamcity api with PowerShell using auth, will return builds
# Set env vars
# [Environment]::SetEnvironmentVariable("user", "user", "User")
# [Environment]::SetEnvironmentVariable("password", "password", "User")


$user = $env:user
$password = $env:password
$pair = "$($user):$($password)"
$url = 'http://IP_Address:8111/app/rest/builds'

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{
    "Authorization" = $basicAuthValue;
    "Accept" = "application/xml";
    "Content-Type" = "application/xml";
}

[xml]$resp = Invoke-RestMethod -Method get -Uri $uri -Headers $headers 

Write-Output $resp