$ProjectRoot = Resolve-Path "$PSScriptRoot\.."
$Root = Resolve-Path "$projectRoot\Remove-MDOldFile"

Get-Module Remove-MDOldFile | Remove-Module -Force

Import-Module $Root\Remove-MDOldFile.psm1 -Force

Describe "Remove-MDOldFile" {
    $TestDrive = 'TestDrive:\'
    Context "Test removal date logic" {
        # Create 3 test files with last write times of 10, 20 and 30 days ago
        10, 20, 30 | ForEach-Object { Set-Content -Value 'Test'-Path $TestDrive+"ofd$_.txt"
            Set-ItemProperty -Path $TestDrive+"ofd$_.txt" -Name 'LastWriteTime' -Value (Get-Date).AddDays(-$_)
        }

        It "It removes no files" {
            Remove-MDOldFile -Path  $TestDrive -NumberOfDaysToKeep 45
            (Get-ChildItem  $TestDrive).count | Should Be 3
        }
        It "It removes 1 file over 25 days old" {
            Remove-MDOldFile -Path  $TestDrive -NumberOfDaysToKeep 25
            (Get-ChildItem $TestDrive).count | Should Be 2
        }
        It "It removes 2 files over 15 days old" {
            Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 11
            (Get-ChildItem $TestDrive).count | Should Be 1
        }
        It "It removes all files over 2 days old" {
            Remove-MDOldFile -Path $TestDrive -NumberOfDaysToKeep 2
            (Get-ChildItem $TestDrive).count | Should Be 0
        }
        It "Warns when a path is not found" {
            Mock Test-Path { return $false }
            Remove-MDOldFile -Path 'TestDrive:\NoPath' -NumberOfDaysToKeep 10 -WarningVariable warn 3> $null
            $warn.message | Should Be 'Path not found'
        }
        Context "File type removal" {
            'txt', 'log', 'etl', 'dll', 'exe', 'msc' | 
            ForEach-Object { Set-Content -Value 'test' -Path $TestDrive+"test.$_" }
 
            It "Does not remove executable files" {
                (Get-ChildItem $TestDrive).count | Should Be 5
            }
        }
    }
}