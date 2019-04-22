task default -depends AnalyseFunction

task AnalyseFunction {
    'Running Script Analyser on the function'
    $FunctionSAResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\Remove-MDOldFile\*.psm1 -Severity @('Error', 'Warning') 
    if ($FunctionSAResults) {
        $FunctionSAResults | Format-Table
        Write-Error -Message 'One or more script analyser errors/ warnings were found'
    }
}