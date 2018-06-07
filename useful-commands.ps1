# Find the sources that can log to an eventlog
(Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application).pschildname

