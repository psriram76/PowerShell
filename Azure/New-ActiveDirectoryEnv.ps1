$ResourceGroupName = "ActiveDirectory"
$vNetName = "AD-Network"
$vNetAddressPrefix = "192.168.0.0/16"
$subnet1Prefix = "192.168.0.0/24"
$subnet1Name = "Office-subnet"
$subnet2Prefix = "192.168.1.0/24"
$subnet2Name = "Subnet1"
$storageAccountName = "mdad"


New-AzureRmResourceGroup -Name $ResourceGroupName -Location "North Europe" -Tag @{Name="Environment";Value="Dev"},@{Name="Department";Value="IT"}

New-AzureRmResourceGroupDeployment -Name "virtual-network" -ResourceGroupName $ResourceGroupName -TemplateFile C:\PowerShell\Azure\101-VNet-2-Subnets\azuredeploy.json -TemplateParameterFile C:\PowerShell\Azure\101-VNet-2-Subnets\azuredeploy.parameters.json -vnetAddressPrefix $vNetAddressPrefix -vnetName $vNetName -subnet1Prefix $subnet1Prefix -subnet1Name $subnet1Name -subnet2Prefix $subnet2Prefix -subnet2Name $subnet1Name

New-AzureRmResourceGroupDeployment -Name "Storage-Account" -ResourceGroupName $ResourceGroupName -TemplateFile C:\PowerShell\Azure\101-storage-account-create\azuredeploy.json -TemplateParameterFile C:\PowerShell\Azure\101-storage-account-create\azuredeploy.parameters.json -storageAccountName $storageAccountName -Verbose


New-AzureRmResourceGroupDeployment -Name "Win-Web-1" -ResourceGroupName $ResourceGroupName -TemplateFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.json -TemplateParameterFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.parameters.json -vmName "test-md-ad-1" -dnsLabelPrefix "test-md-ad-1" -adminUsername "mdwinad1suser" -internalIPAddress "192.168.0.2" -Verbose

New-AzureRmResourceGroupDeployment -Name "Win-Web-2" -ResourceGroupName $ResourceGroupName -TemplateParameterFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.parameters.json -TemplateFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.json -vmName "test-md-web-2" -dnsLabelPrefix "test-md-web-2" -adminUsername "mdwinweb2suser" -Verbose




Remove-AzureRmResourceGroup -Name Dev-MD

#delete vms + assets...
$vmName = "test-md-centos"
$rgName = "PS-Test-RG"
$ddName = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName | Select-Object -ExpandProperty datadisknames

Remove-AzureRmVM -Name $vmName -ResourceGroupName $rgName

Get-AzureRmNetworkInterface -VirtualMachineScaleSetName