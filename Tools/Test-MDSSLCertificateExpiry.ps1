<#
.SYNOPSIS
    Tests when an SSL certificate will expire
.DESCRIPTION
    Uses Get-MDSSLCertificateExpiry cmdlet to get the certificate expiry date.
    It then converts the returned string to a datetime type and compares with the date.
    Set to alert for certs that are expiring in 14 days and under
.EXAMPLE
    PS C:\> <example usage>
    Explanation of what the example does
.INPUTS
    Inputs (if any)
.OUTPUTS
    Output (if any)
.NOTES
    General notes
#>

# We get date return: '16/10/2019 19:59:59'
# We need it in this format: 66/1-06-15T13:45:30
# https://docs.microsoft.com/en-us/dotnet/standard/base-types/standard-date-and-time-format-strings
$date = Get-Date

$ReturnedExpiryDate = Get-MDSSLCertificateExpiry -Uri 'https://matthewdavis111.com'
$SplitExpiryDate = $ReturnedExpiryDate.Split('/')
$SplitExpiryDate = $SplitExpiryDate.split(' ')

# Create the expiry date to compare in datetime format
[datetime]$ExpiryDate = $SplitExpiryDate[2] + '-' + $SplitExpiryDate[1] + '-' + $SplitExpiryDate[0] + 'T' + $SplitExpiryDate[3]



# Alert if there is less than 14 days until expiry
$ExpiryDate.AddDays(-14) -lt $date

Write-Output "$uri Cert expires on the $ExpiryDate"


# Message to slack
$SlackHook = ''
$Message = "$uri Cert expires on the $ExpiryDate"

function New-SlackMessage {
    param(
        # URI of Slack Hook
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $URI,
        # Message To Send
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $Message
    )
    
    $payload = @{
        'text' = $Message
    }

    Invoke-WebRequest -Body (ConvertTo-Json -Compress -InputObject $payload) -Method Post -Uri $SlackHook | Out-Null
}
