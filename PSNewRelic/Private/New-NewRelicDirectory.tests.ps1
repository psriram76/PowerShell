# this is a Pester test file

#region Further Reading
# http://www.powershellmagazine.com/2014/03/27/testing-your-powershell-scripts-with-pester-assertions-and-more/
#endregion
#region LoadScript
# load the script file into memory
# attention: make sure the script only contains function definitions
# and no active code. The entire script will be executed to load
# all functions into memory
. ($PSCommandPath -replace '\.tests\.ps1$', '.ps1')
#endregion

# describes the function New-NewRelicDirectory
Describe 'New-NewRelicDirectory' {
  $testDrive = 'TestDrive\'
  Context 'Input' {
    It 'accept a new directory name'
    New-NewRelicDirectory -Name 'test' -ComputerName 'localhost' | Should Be $true
  }
  Context 'Execute' {}
  Context 'Output' {}
}


