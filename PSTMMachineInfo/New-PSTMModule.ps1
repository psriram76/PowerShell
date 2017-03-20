New-ModuleManifest -Path .\PSTMMachineInfo.psd1 
-Author "Matt Davis" 
-RootModule .\PSTMMachineInfo.psm1
-FunctionsToExport @('Get-TMMachineInfo') 
-Description "Sample Toolmaking module" 
-ModuleVersion 1.0.0.0