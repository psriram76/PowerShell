Task default -depends Test

Task AnalysePlugin {
    $moduleResults = Invoke-ScriptAnalyzer -Path $PSScriptRoot\poshbot-plugin\*.psm1  -Severity @('Error', 'Warning')
    if ($moduleResults) {
        $moduleResults | Format-Table
        Write-Error -Message 'One or more script analyser errors/ warnings were found'
    }
}

Task test -depends AnalysePlugin {
    'running tests'
}

Task deployQA -depends test {
    'Deploying to QA'
    $server = '192.168.33.20'
    Invoke-PSDeploy -Tags QA -Force
}

Task deployProd -depends test {
    'Deploying to prod'
    Invoke-PSDeploy -Tags Prod -Force
}