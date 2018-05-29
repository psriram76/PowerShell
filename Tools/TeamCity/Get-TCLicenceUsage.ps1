<#

#>

$baseUrl = 'http://51.143.152.188:8111/app/rest/'


# Code for authentication
$Credentials = Get-Credential -Credential $null
$RESTAPIUser = $Credentials.UserName
$Credentials.Password | ConvertFrom-SecureString
$RESTAPIPassword = $Credentials.GetNetworkCredential().password

$pair = "$($RestAPIUser):$($RESTAPIPassword)"

$encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$basicAuthValue = "Basic $encodedCreds"
$headers = @{
    "Authorization" = $basicAuthValue;
    "Accept" = "application/xml";
    "Content-Type" = "application/xml";
}

# Custom object to hold the data
$licenceStats = [PSCustomObject]@{
  MaxAgents = $null;
  AgentsLeft = $null;
  AuthAgentCount = $null;
  AuthConnectedAgentCount = $null;
  AuthDisconnectedAgentCount = $null
  Date = Get-Date -Format yyyy-MM-dd;
  Time = Get-Date -Format HH:mm
}

# Overall licence data
$licenceDataUrl = $baseUrl + 'server/licensingData'
[xml]$licenceData =   Invoke-RestMethod -Method Get -UseBasicParsing -Uri $licenceDataUrl -Headers $headers
$licenceStats.MaxAgents = $licenceData.licensingData.maxAgents
$licenceStats.AgentsLeft = $licenceData.licensingData.agentsLeft

# Count total authorised agents
$agentUrl = $baseUrl + 'agents?locator=authorized:true'
[xml]$authorisedAgents = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $agentUrl -Headers $headers
$licenceStats.AuthAgentCount = $authorisedAgents.agents.count

# Authorised agents that are connected
$connectedLocator = $agentUrl + ',connected:true'
[xml]$authAgentConnected = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $connectedLocator -Headers $headers
$licenceStats.AuthConnectedAgentCount = $authAgentConnected.agents.count

# Authorised agents that are disconnected
$disconnectedLocator = $agentUrl + ',connected:false'
[xml]$authAgentsDisconnected = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $disconnectedLocator -Headers $headers
$licenceStats.AuthDisconnectedAgentCount = $authAgentsDisconnected.agents.count

Return $licenceStats

Export-Csv -InputObject $licenceStats -Path 'C:\#temp\test.csv' -Force -NoTypeInformation -Append