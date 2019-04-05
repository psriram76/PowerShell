Import-Module -Name ActiveDirectory

$Width = 80

function Get-ADComputerStatus {
    <#
    .SYNOPSIS
    Get the status of an AD Computer

    .EXAMPLE
    !Get-ADComputerStatus lap123
    Gets the account status of the Computer lap123
    .INPUTS
    AD identity
    .OUTPUTS
    Output (if any)
    .NOTES
    General notes
    #>

    [PoshBot.BotCommand(
        CommandName = 'adcomputerstatus',
        Permissions = 'read',
        Aliases = ('cs', 'computerstatus')
    )]

    [CmdletBinding()]
    param (
        # Identity of AD computer
        [Parameter(Position = 0)]
        [String]
        $Identity
    )

    $computer = Get-ADComputer -Filter { Name -eq $Identity }
    
    if ($computer) {
        $properties = [ordered]@{
            Enabled         = $computer.Enabled
            LockedOut       = $computer.LockedOut
            PasswordExpired = $computer.PasswordExpired
            PaswordLastSet  = $computer.PasswordLastSet
        }
        $computerStatus = New-Object -TypeName psobject -Property $properties
        $Title = "Computer Name $($computer.Name)"
        $o = $computerStatus | Out-String -Width $Width
        $Type = 'Normal'

    } else {
        $Title = 'Computer Not found'  
        $o = "Unable to find computer with the Name $Identity"
        $Type = 'Warning'
    }
    
    New-PoshBotCardResponse -Title $Title -Type $Type -Text $o
}

Export-ModuleMember -Function Get-ADComputerStatus