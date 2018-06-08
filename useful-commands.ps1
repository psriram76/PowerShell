# Place to store useful oneliners

# Find the sources that can log to an eventlog
(Get-ChildItem HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\Application).pschildname


# Remove a user / group from directories - must remove inheritance first
# Remove inheritance
$acl = Get-Acl -Path $folderName
$acl.SetAccessRuleProtection($true,$true)
Set-Acl -Path $folderName -AclObject $acl

# Remove user access
$acl = Get-Acl -Path $folderName
$acl.Access | Where-Object {$_.IdentityReference -eq "BUILTIN\Users" } | ForEach-Object { $acl.RemoveAccessRuleSpecific($_) }
Set-Acl -Path $folderName -AclObject $acl
