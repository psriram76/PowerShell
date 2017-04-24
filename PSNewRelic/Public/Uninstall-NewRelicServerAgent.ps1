<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Uninstall-NewRelicServerAgent
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([int])]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true)]
        $Session
    )

    Begin
    {
    }
    Process
    {
        Invoke-Command -Session $session -ScriptBlock {$app = Get-WmiObject -Query "select * from win32_product where Name LIKE 'NEW Relic Server Monitor'"}
        Invoke-Command -Session $session -ScriptBlock {$app.uninstall()}
        Start-Sleep -Seconds 10
    }#process
    End
    {
    }
}


