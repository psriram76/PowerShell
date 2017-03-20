﻿<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function Verb-Noun
{
    [CmdletBinding()]
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        [String]
        $ServiceName,

        # Param2 help description
        [String]
        $NewPassword,
        [String]
        $NewUser,
        [String]
        $ComputerName
    )

    Begin
    {
    }
    Process
    {
        Invoke-CimMethod -Query "SELECT * FROM win32_service WHERE name = $ServiceName" -MethodName change -Arguments
    }
    End
    {
    }
}