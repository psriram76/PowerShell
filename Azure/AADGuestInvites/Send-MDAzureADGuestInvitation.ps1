<#
.SYNOPSIS
    Invite guest users to Azure Active Directory for demo application.
.DESCRIPTION
    Users to be provided in CSV file with the headings 'username,email'.
    Users will be be checked to see if they have been invited to Azure AD as a guest user previously. If there is already an invite, then no action will be take, if a user doesn't exist in Azure AD, then an invite will be sent.
    Output will be logged to the job output in Azure.
    A message will be posted to the slack room advising on the number of users invited.
.NOTES
    https://docs.microsoft.com/en-us/azure/active-directory/b2b/b2b-quickstart-invite-powershell
#>

Import-Module -Name 'AzureAD'

$demoAppGroupId = ''
$date = Get-Date -Format yyyy-MM-dd
$csvPath = "$env:tmp\test.csv"
$inviteCounter = 0
$csvUri = Get-AutomationVariable -Name 'demoApp-storage-sas'
$creds = Get-AutomationPSCredential -Name 'demoApp-invite-user'
$slackUri = Get-AutomationVariable -Name 'demoAppSlackWebHookUri'

try {
    Connect-AzureAD -Credential $creds | Out-Null
    Write-Output 'Connected to AzureAD'
}
catch {
    throw "Failed to connect to AzureAD: $_.Exception.Message"
}

#region Slack helper function
function New-MDSlackMessage {
    param(
        # URI of Slack Hook
        [Parameter(Mandatory = $true, Position = 0)]
        [string]
        $Uri,
        # Message To Send
        [Parameter(Mandatory = $true, Position = 1)]
        [string]
        $Message
    )
    $payload = @{
        "text" = $Message
    }

    Invoke-RestMethod -Method Post -Uri $Uri -Body (ConvertTo-Json -InputObject $payload -Compress) -UseBasicParsing | Out-Null
}
#endregion

#region get csv file
try {
    Invoke-WebRequest -Uri $csvUri -OutFile $csvPath
}
catch {
    throw "Failed to connect to download guest.csv file from demoAppstorage: $_.Exception.Message"
}
$userList = Import-Csv -Path $csvPath
#endregion

$ExistingGuestUserList = Get-AzureADUser -All $true -Filter "userType eq 'Guest'"

foreach($user in $userList){
    $displayName = "$($user.username)"
    $url = 'https://myapps.microsoft.com/?tenantid=tenantIDHere'

    # User has potentially been invited before, need to check
    if($user.email -in $ExistingGuestUserList.mail) {
        Write-Output "User with email address already has been invited: $($user.email)"
    }
    else {
        $invite = New-AzureADMSInvitation -InvitedUserDisplayName $displayName -InvitedUserEmailAddress $user.email -SendInvitationMessage $true -InviteRedirectUrl $url
        Add-AzureADGroupMember -ObjectId $demoAppGroupID -RefObjectId $invite.InvitedUser.Id
        Write-Output "$($invite.InvitedUserEmailAddress) invited on $date. Added to demoApp AAD group." 
        $inviteCounter ++
    }
}

$message =  "$($inviteCounter) new external user(s) invited to Azure AD to access demoApp."
Write-Output $message
New-MDSlackMessage -Uri $slackUri -Message $message

Disconnect-AzureAD
Write-Output 'Finished runbook and disconnected from AzureAD'
