<#
.Synopsis
   Download the latest sysinternals tools
.DESCRIPTION
   Downloads the latest sysinternals tools from https://live.sysinternals.com/ to a specified directory
   The function downloads all .exe and .chm files available
.EXAMPLE
   Update-Sysinternals -Path C:\sysinternals
   Downloads the sysinternals tools to the directory C:\sysinternals
.EXAMPLE
   Update-Sysinternals -Path C:\Users\Matt\OneDrive\Tools\sysinternals>
   Downloads the sysinternals tools to a user's OneDrive
#>
function Update-Sysinternals {
    [CmdletBinding()]
    param (
        # Path to the directory were sysinternals tools will be downloaded to 
        [Parameter(Mandatory=$true)]
        [string]
        $Path 
    )
    
    begin {
            $uri = 'https://live.sysinternals.com/'
            $sysToolsPage = Invoke-WebRequest -Uri $uri
            # create dir if it doesn't exist    
            if (-not (Test-Path -Path $Path)){
                New-Item -Path $Path -ItemType Directory
            }
    }
    
    process {
        Set-Location -Path $Path

        $sysTools = $sysToolsPage.Links.innerHTML | Where-Object -FilterScript {$_ -like "*.exe" -or $_ -like "*.chm"} 

        foreach ($sysTool in $sysTools){
            Invoke-WebRequest -Uri "$uri/$sysTool" -OutFile $sysTool
        }
    } #process
}





