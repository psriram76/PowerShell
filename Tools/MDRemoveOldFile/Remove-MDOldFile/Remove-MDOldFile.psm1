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
        $NumberOfDaysToKeep,
        # File Type to remove
        [Parameter(Mandatory = $true)]
        [string]
        [ValidateSet("log", "txt", "etl")]
        $FileType
    )
    
    begin {
    }
    
    process {
        if (Test-Path $Path) {
            Get-ChildItem -Path $Path | Where-Object -FilterScript { $_.LastWriteTime -LT (Get-Date).AddDays(-$NumberOfDaysToKeep) -and $_.Name -like "*.$FileType" }|
            Remove-Item -Force 
        } else {
            Write-Warning "Path not found"
        }
    }
    
    end {
    }
}
