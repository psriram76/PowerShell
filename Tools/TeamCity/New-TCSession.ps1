<#
#>
function New-TCSession {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory)]
    [ValidateNotNull()]
    [System.Management.Automation.PSCredential]
    $Credential,
    [Parameter(Mandatory)]
    [string]
    $Uri
  )
  
  begin {
  }
  
  process {
    # Code for authentication
    $RESTAPIUser = $Credential.UserName
    $Credential.Password | ConvertFrom-SecureString | Out-Null
    $RESTAPIPassword = $Credential.GetNetworkCredential().password

    $pair = "$($RestAPIUser):$($RESTAPIPassword)"

    $encodedCreds = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
    $basicAuthValue = "Basic $encodedCreds"
    $headers = @{
      "Authorization" = $basicAuthValue;
      "Accept"        = "application/xml";
      "Content-Type"  = "application/xml";
    }

    # Connect to server to create a session
    try {
      $server = "$Uri" + "/app/rest/server"
      $session = $null
      $response = Invoke-RestMethod -Method Get -UseBasicParsing -Uri $server -Headers $headers -SessionVariable session
      New-Object psobject -Property @{
        session = $session
      }

    }
    catch [System.Net.WebException] {
      Write-Output $_.exception.message
    }
    Return $session
  }
  
  end {
  }
}




