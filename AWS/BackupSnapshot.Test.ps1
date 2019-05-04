Describe "Test Backup Policy Integrity" {
    # Test all volumes attached to an EC2 instance have a backup policy tag that match.
    # Test that there is a completed snapshot taken within the last 24 hours

    # Get all instances with a backup plan tag and 
    $EC2List = Get-EC2Instance -Filter @{name = 'tag-key' ; Values = 'BackupPolicy'}
    
    # Loop through all EC2 instances getting their name, backup policy and attached volumes
    $EC2List | ForEach-Object {
        $EC2Name = ($_.Instances.Tags | Where-Object -Property Key -eq 'Name').Value
        $InstanceBackupPolicy = ($_.Instances.tag | Where-Object key -eq BackupPolicy).value
        $VolumeIdList = $_.Instances.BlockDeviceMappings.ebs.volumeid

        # Loop through and test all attached volumes and corresponding snapshots
        $VolumeIdList | ForEach-Object {
            $VolumeBackupPolicy = ((Get-EC2Volume $_).tags | Where-Object -Property Key -eq 'BackupPolicy').value

            # Get a list of snapshots for the volume and get the latest one  
            $SnapshotList = Get-EC2Snapshot -Filter @{name='volume-id';values="$_"}
            $LatestSnapshot = $SnapshotList | Sort-Object -Property StartTime -Descending | Select-Object -First 1
            
            Context "Backup Policy tests for $EC2Name $InstanceBackupPolicy" {
                It "Volume $_ backup policy matches instance backup policy: $VolumeBackupPolicy" {
                    $InstanceBackupPolicy -eq $VolumeBackupPolicy | Should Be $true
                }
            }
            Context "Backup Snapshot tests $EC2Name Volume: $_" {
                it "Has a completed snapshot taken within 24 hours. Latest Snapshot: $($LatestSnapshot.StartTime)" {
                    $LatestSnapshot.StartTime -gt (get-date).AddHours(-24) -and $LatestSnapshot.state -eq 'completed' |
                    Should Be $true
                }
            }
        }# end ForEach-Object Volumes
    }# end ForEach-Object EC2 instaces
}# end Describe
