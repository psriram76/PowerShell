<#
.DESCRIPTION
Displays the amount of MBs used for each subdirectory for a given directory
.EXAMPLE
#>
function Get-DirectorySize {
  [CmdletBinding()]
  # Parameter help description
  param(
    [Parameter(Mandatory)]
    [string]
    $Path

  )
  
  begin {
  }
  
  process {
    if (-not (Test-Path -Path $Path)) {
      Throw "The Path $Path does not exist"
    }
    
    $SubDirectoryList = Get-ChildItem -Path $Path -Directory
    $directoryInfoList = @()

    foreach ($directory in $SubDirectoryList) {
      $directoryInfo = [PSCustomObject]@{
        Name      = $null;
        Items     = 0;
        Size = 0;
      }

      $subDirectory = Get-ChildItem -Path (Join-Path -Path $ParentDirectory -ChildPath $directory.Name) -Recurse
      $length = $subDirectory | ForEach-Object {$_.Length} | Measure-Object -Sum | Select-Object -Property @{l = "sum"; e = {"$($_.Sum)" / 1MB -as [int]}}

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

