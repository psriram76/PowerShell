<#
.SYNOPSIS
    Find all CloudTrails in all AWS regions and remove them if needed
.DESCRIPTION
    Iterate over all regions and output any cloudtrail found with the specified name.
    Handy if cloudtrails were created before a multiregion trail was available and used to remove old trails
    and set up a single multiregion trail.
#>

$RegionList = Get-AWSRegion
$CloudTrailName = 'Default'


foreach ($region in $RegionList) {
    Get-CTTrail -Region $region.region | Where-Object { $_.name -eq $CloudTrailName }
}

# Remove all cloudtrails whatif added for safety - remove WhatIf to remove the trails.
foreach ($region in $RegionList) {
    Get-CTTrail -Region $region.region | Where-Object { $_.name -eq $CloudTrailName } | Remove-CTTrail -Force -Region $region.region -WhatIf
}
