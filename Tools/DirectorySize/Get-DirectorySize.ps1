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
      # custom object to save the directory information
      $directoryInfo = [PSCustomObject]@{
        Name  = $null;
        Items = 0;
        Size  = 0;
      }

      # Save all child items of the directory passed to the loop
      $subDirectory = Get-ChildItem -Path (Join-Path -Path $ParentDirectory -ChildPath $directory.Name) -Recurse
      # Get the sum of all of the childitems length in the subdirectory to find total bytes used
      $length = $subDirectory | ForEach-Object {$_.Length} | Measure-Object -Sum | Select-Object -Property Sum

      # Add properties to the custom object
      $directoryInfo.Name = $directory.Name
      $directoryInfo.Items = $subDirectory.Count
      $directoryInfo.Size = $length.sum
  
      # Add the ojbect to the array
      $directoryInfoList += $directoryInfo
  
    }

    Return $directoryInfoList
  }
  
  end {
  }
}

