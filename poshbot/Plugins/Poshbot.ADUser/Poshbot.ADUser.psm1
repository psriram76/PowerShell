Import-Module -Name ActiveDirectory

$Width = 80

function Get-ADUserStatus {
    <#
    .SYNOPSIS
    Get the status of an AD user

    .EXAMPLE
    !Get-ADUserStatus test.mctest
    Gets the account status of the user test.mctest
    .INPUTS
    AD identity
    .OUTPUTS
    Output (if any)
    .NOTES
    General notes
#>

    [PoshBot.BotCommand(
        CommandName = 'aduserstatus',
        Permissions = 'read',
        Aliases = ('us', 'userstatus')
    )]

    [CmdletBinding()]
    param (
        # Identity of AD User
        [Parameter(Position = 0)]
        [String]
        $Identity
    )

    # Get user(s)

    $user = Get-ADUser -Filter { SamAccountName -eq $Identity } -Properties Enabled, LockedOut, PasswordExpired, PasswordLastSet, LastBadPasswordAttempt

    if ($user) {
        $properties = [ordered]@{
            Enabled                = $user.Enabled
            LockedOut              = $user.LockedOut
            PasswordExpired        = $user.PasswordExpired
            PaswordLastSet         = $user.PasswordLastSet
            PasswordExpires        = ($user.PasswordLastSet).AddDays(90)
            LastBadPasswordAttempt = $user.LastBadPasswordAttempt
        }

        $userStatus = New-Object -TypeName psobject -Property $properties

        $Title = "SamAccountName $($user.SamAccountName)" 
        $o = $userStatus | Format-List | Out-String -Width $Width
        $Type = 'Normal'
    } else {
        $Title = 'User Not found'  
        $o = "Unable to find user with the SamAccountName $Identity"
        $Type = 'Warning'
    }

    New-PoshBotCardResponse -Title $Title -Type $Type -Text $o
}

Export-ModuleMember -Function Get-ADUserStatus