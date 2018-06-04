<#
.DESCRIPTION
Displays the amount of bytes used for each subdirectory for a given directory
.EXAMPLE
Get-DirectorySize -Path 'C:\Program Files'
.Example
Get-DirectorySize -Path 'C:\Windows' -IncludePathFiles
#>
function Get-DirectorySize {
  [CmdletBinding()]
  # Path of the directory to find the size of the subdirectories
  param(
    [Parameter(Mandatory)]
    [string]
    $Path,
    # Include files at the parent path level in the output
    [switch] 
    $IncludePathFiles

  )
  
  begin {
  }
  
  process {
    if (-not (Test-Path -Path $Path)) {
      Throw "The Path $Path does not exist"
    }
    
    if ($IncludePathFiles) {
      $SubDirectoryList = Get-ChildItem -Path $Path      
    }
    else {
      $SubDirectoryList = Get-ChildItem -Path $Path -Directory      
    }
    $directoryInfoList = @()

    foreach ($directory in $SubDirectoryList) {
      $directoryInfo = [PSCustomObject]@{
        Name  = $null;
        Items = 0;
        Size  = 0;
      }

      $subDirectory = Get-ChildItem -Path (Join-Path -Path $ParentDirectory -ChildPath $directory.Name) -Recurse
      $length = $subDirectory | ForEach-Object {$_.Length} | Measure-Object -Sum | Select-Object -Property Sum

      $directoryInfo.Name = $directory.Name
      $directoryInfo.Items = $subDirectory.Count
      $directoryInfo.Size = $length.sum
  
      $directoryInfoList += $directoryInfo
  
    }

    Return $directoryInfoList
  }
  
  end {
  }
}

