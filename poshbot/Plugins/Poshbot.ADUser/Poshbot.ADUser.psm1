Import-Module -Name ActiveDirectory

$Width = 80
$CommandsToExport = @()

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
        Aliases = ('userstatus', 'us')
    )]

    [CmdletBinding()]
    param (
        # Identity of AD User
        [Parameter(Position = 0)]
        [String]
        $Identity
    )
  
    $user = Get-ADUser -Identity $Identity -Properties Enabled, LockedOut, PasswordExpired, PasswordLastSet 
    $o = $user | Select-Object -Property  SamAccountName, Enabled, LockedOut, PasswordExpired, PasswordLastSet | Out-String -Width $Width

    New-PoshBotCardResponse -Type Normal -Text $o
}

$CommandsToExport += Invoke-SiteStatus

Export-ModuleMember -Function Get-ADUserStatus