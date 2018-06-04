$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Get-DirectorySize' {
  It 'Throws an exception if a path is not found' {
    Mock Test-Path {
      $false
    }
    Get-DirectorySize -Path 'c:\non-existant' | Should Throw
  }
}