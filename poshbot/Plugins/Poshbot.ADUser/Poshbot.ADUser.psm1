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
    
    
    $properties = [ordered]@{
        SamAccountName  = $user.SamAccountName
        Enabled         = $user.Enabled
        LockedOut       = $user.LockedOut
        PasswordExpired = $user.PasswordExpired
        PaswordLastSet  = $user.PasswordLastSet
        PasswordExpires = ($user.PasswordLastSet).AddDays(90)
    }
    
    $userStatus = New-Object -TypeName psobject -Property $properties
    
    $o = $userStatus | Out-String -Width $Width
    
    New-PoshBotCardResponse -Type Normal -Text $o

}

Export-ModuleMember -Function Get-ADUserStatus