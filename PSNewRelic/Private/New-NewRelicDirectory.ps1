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
function New-NewRelicDirectory
{
    [CmdletBinding()]
    [Alias()]
    [OutputType([String])]
    Param
    (
        # Param1 help description
        [String]
        $Name = 'newrelic',
        [Parameter(Mandatory=$true)]
        [String]
        $ComputerName
    )

    Process
    {
      if(-Not (Test-Path -Path \\$ComputerName\c$\$Name)){            
            New-Item -Path \\$ComputerName\c$\$Name -ItemType Directory
        } 
    } #process
}
