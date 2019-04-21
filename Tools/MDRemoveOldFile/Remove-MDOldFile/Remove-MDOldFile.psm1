function Remove-MDOldFile {
    [CmdletBinding()]
    param (
        # Path of directory
        [Parameter()]
        [string]
        $Path,
        # Number of days to keep
        [Parameter()]
        [int]
        $NumberOfDaysToKeep = 7
    )
    
    begin {
    }
    
    process {
        Get-ChildItem -Path $Path | Where-Object -Property 'LastWriteTime' -LE (Get-Date).AddDays( -$NumberOfDaysToKeep) |
        Remove-Item -Force
    }
    
    end {
    }
}
