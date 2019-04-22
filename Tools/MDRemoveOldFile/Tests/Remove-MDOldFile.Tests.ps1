$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$Root = Resolve-Path "$projectRoot\Remove-MDOldFile"

Get-Module Remove-MDOldFile | Remove-Module -Force

Import-Module $Root\Remove-MDOldFile.psm1 -Force

Describe "Remove-MDOldFile" {
    Context "Test removal date logic" {
        $oldFile1Day = "TestDrive:\of1d.txt"
        $oldFile2Day = "TestDrive:\of2d.txt"
        $oldFile3Day = "TestDrive:\of3d.txt"

        Set-Content -Path $oldFile1Day -Value 'test'
        Set-Content -Path $oldFile2Day -Value 'test'
        Set-Content -Path $oldFile3Day -Value 'test'

        Set-ItemProperty -Path $oldFile1Day -Name 'LastWriteTime' -Value (Get-Date).AddDays(-10)
        Set-ItemProperty -Path $oldFile2Day -Name 'LastWriteTime' -Value (Get-Date).AddDays(-20)
        Set-ItemProperty -Path $oldFile3Day -Name 'LastWriteTime' -Value (Get-Date).AddDays(-30)

        It "It removes no files" {
            Remove-MDOldFile -Path 'TestDrive:\' -NumberOfDaysToKeep 45
            (Get-ChildItem 'TestDrive:\').count | Should Be 3
        }
        It "It removes 1 file over 25 days old" {
            Remove-MDOldFile -Path 'TestDrive:\' -NumberOfDaysToKeep 25
            (Get-ChildItem 'TestDrive:\').count | Should Be 2
        }
        It "It removes 2 files over 15 days old" {
            Remove-MDOldFile -Path 'TestDrive:\' -NumberOfDaysToKeep 11
            (Get-ChildItem 'TestDrive:\').count | Should Be 1
        }
        It "It removes all files over 2 days old" {
            Remove-MDOldFile -Path 'TestDrive:\' -NumberOfDaysToKeep 2
            (Get-ChildItem 'TestDrive:\').count | Should Be 0
        }
        It "Warns when a path is not found" {
            Mock Test-Path { return $false }
            Remove-MDOldFile -Path 'TestDrive:\NoPath' -NumberOfDaysToKeep 10 -WarningVariable warn 3> $null
            $warn.message | Should Be 'Path not found'
        }
    }
}