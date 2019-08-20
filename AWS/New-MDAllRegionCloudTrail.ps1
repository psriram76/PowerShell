<#
.SYNOPSIS
    Create an AWS multiregion CloudTrail and S3 bucket logging all data events for S3 and lambda services.
.DESCRIPTION
    This script creates an S3 bucket with public access blocked for CloudTrail logs. 
    The CloudTrail created is a multiregion trail that logs all data events for S3 and Lambda.
    An IAM user or role is required to have permissions to create a CloudTrail and S3 bucket.
.NOTES
    General notes
#>

$AccountName = Get-IAMAccountAlias
$AccountNumber = (Get-STSCallerIdentity).account
$BucketName = "cloudtrail-$AccountNumber"
$CloudTrailName = 'matt-cloudtrail'

#region S3Bucket

# Bucket Policy to allow CloudTrail to write logs to the bucket
$S3CloudTrailPolicy = @"
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AWSCloudTrailAclCheck20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:GetBucketAcl",
            "Resource": "arn:aws:s3:::$BucketName"
        },
        {
            "Sid": "AWSCloudTrailWrite20150319",
            "Effect": "Allow",
            "Principal": {
                "Service": "cloudtrail.amazonaws.com"
            },
            "Action": "s3:PutObject",
            "Resource": "arn:aws:s3:::$BucketName/AWSLogs/$AccountNumber/*",
            "Condition": {
                "StringEquals": {
                    "s3:x-amz-acl": "bucket-owner-full-control"
                }
            }
        }
    ]
}
"@


# Create S3 bucket and apply the bucket policy
New-S3Bucket -BucketName $BucketName
Write-S3BucketPolicy -BucketName $BucketName -Policy $S3CloudTrailPolicy

# Block public access for the bucket and objects
$s3PublicParams = @{
    BucketName                                          = $BucketName
    PublicAccessBlockConfiguration_BlockPublicAcl       = $true
    PublicAccessBlockConfiguration_BlockPublicPolicy    = $true
    PublicAccessBlockConfiguration_IgnorePublicAcl      = $true
    PublicAccessBlockConfiguration_RestrictPublicBucket = $true
}

Add-S3PublicAccessBlock @s3PublicParams
#endregion S3Bucket

#region CloudTrail
$params = @{
    Name                      = $CloudTrailName
    S3BucketName              = $BucketName
    EnableLogFileValidation   = $true
    IsMultiRegionTrail        = $true
    IncludeGlobalServiceEvent = $true
}

# Create trail
New-CTTrail @params

# Create description tag and add to trail
$tag = New-Object -TypeName Amazon.CloudTrail.Model.Tag
$tag.Key = 'Description'
$tag.Value = 'All region Cloudtrail logging all data events for S3 and Lambda.'

Add-CTTag -ResourceId  (Get-CTTrail -TrailNameList $CloudTrailName).TrailARN -TagsList $tag

# Create CloudTrail event selector object
$EventSelector = New-Object -TypeName Amazon.CloudTrail.Model.EventSelector
$EventSelector.IncludeManagementEvents = $true
$EventSelector.ReadWriteType = 'All'

# S3 data resource
$S3DataResource = New-Object -TypeName Amazon.CloudTrail.Model.DataResource 
$S3DataResource.Type = 'AWS::S3::Object'
$S3DataResource.Values = 'arn:aws:s3'

# Lambda data resource
$LambdaDataResource = New-Object -TypeName Amazon.CloudTrail.Model.DataResource 
$LambdaDataResource.Type = 'AWS::Lambda::Function'
$LambdaDataResource.Values = 'arn:aws:lambda'

# Add data resources to event selector and update CloudTrail
$EventSelector.DataResources = $S3DataResource, $LambdaDataResource
Write-CTEventSelector -TrailName $CloudTrailName -EventSelector $EventSelector

# Start CloudTrail logging
Start-CTLogging -Name $CloudTrailName
#endregion CloudTrail

