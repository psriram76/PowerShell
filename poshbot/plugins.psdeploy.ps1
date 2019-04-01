Deploy PluginsToQA {
    By FileSystemRemote QA {
        FromSource 'poshbot-plugin'
        To '\\192.168.33.20\temp'
        Tagged QA
        WithOptions @{
            ComputerName = $server
            Credential   = $cred
        }
    }
    By FileSystem Prod {
        FromSource 'poshbot-plugin'
        To 'C:\Temp\poshbotprod\poshbot-plugin'
        Tagged Prod
    }
}