$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Update-Sysinternals'{
    Context 'Input'{
        It 'Throws an exception if the path is not found' {
            Mock Test-Path {
                $false
            }
            Update-Sysinternals -Path 'C:\nonsense' | Should throw "Cannot validate argument on parameter 'Path'. The Path C:\nonsense does not exist"
        }
    }
    Context 'Execution'{

    }
    Context 'Output'{

    }
}