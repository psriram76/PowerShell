# get -trails

foreach($region in $RegionList){
    Get-CTTrail -Region $region.region | Where-Object {$_.name -eq 'Default'}
}

# Remove all cloudtrails
foreach($region in $RegionList){
    Get-CTTrail -Region $region.region | Where-Object {$_.name -eq 'Default'} | Remove-CTTrail -Force -Region $region.region
}
