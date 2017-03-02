$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Get-MDComputerInfo'{
    Context 'Input'{
        It 'Throws an exception if the computer is not found' {
            Mock Test-Connection {
            $false
            }
            Get-MDComputerInfo -ComputerName 'localhost' | Should be $true
        }
    }
    Context 'Execution'{

    }
    Context 'Output'{

    }
}