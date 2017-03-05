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
        $query = "Name LIKE 'New Relic .NET Agent (64-bit)'"
        Invoke-Command -Session $session -ScriptBlock {$app = Get-WmiObject -Class win32_product -Filter $query}
       # Invoke-Command -Session $session -ScriptBlock {$app.uninstall()}
        Start-Sleep -Seconds 10
    }#process
    End
    {
    }
}
