function Remove-MDOldFile {
    [CmdletBinding(
        SupportsShouldProcess = $True
    )]
    param (
        # Path of directory
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Path,
        # Number of days to keep
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [int]
        $NumberOfDaysToKeep
    )
    
    begin {
    }
    
    process {
        if (Test-Path $Path) {
            Get-ChildItem -Path $Path | Where-Object -Property 'LastWriteTime' -LT (Get-Date).AddDays(-$NumberOfDaysToKeep) |
            Remove-Item -Force    
        } else {
            Write-Warning "Path not found"
        }
    }
    
    end {
    }
}
