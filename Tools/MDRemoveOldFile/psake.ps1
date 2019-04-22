task default -depends AnalyseFunction

task AnalyseFunction {
    'Running Script Analyser on the function'
    $FunctionSAResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\Remove-MDOldFile\*.psm1 -Severity @('Error', 'Warning') 
    if ($FunctionSAResults) {
        $FunctionSAResults | Format-Table
        Write-Error -Message 'One or more script analyser errors/ warnings were found'
    }
}

task RunTests {
    'Running Pester test on the function'
    $TestResults = Invoke-Pester -Path $PSScriptRoot\Tests\*.Tests.ps1 -PassThru
    if ($TestResults.FailedCount -gt 0) {
        $TestResults | Format-Table
        Write-Error -Message 'One or more pester tests failed.'
    }
}

task DeployModule -depends AnalyseFunction, RunTests {
    'Deploying module'
    Copy-Item $PSScriptRoot\Remove-MDOldFile -Destination C:\TEMP -Recurse -Force
}