# Set up a vm with PowerShell and choco for PS development

# Install choco
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

#Install choco packages
choco install sysinternals
choco install vscode

# code --install-extension powershell.vsix
