New-AzureRmResourceGroup -Name Dev-MD -Location "North Europe" -Tag @{Name="Environment";Value="Dev"},@{Name="Department";Value="IT"}

New-AzureRmResourceGroupDeployment -Name "virtual-network" -ResourceGroupName "Dev-MD" -TemplateParameterFile C:\PowerShell\Azure\101-VNet-2-Subnets\azuredeploy.parameters.json -TemplateFile C:\PowerShell\Azure\101-VNet-2-Subnets\azuredeploy.json -Verbose

New-AzureRmResourceGroupDeployment -Name "Storage-Account" -ResourceGroupName "Dev-MD" -TemplateParameterFile C:\PowerShell\Azure\101-storage-account-create\azuredeploy.parameters.json -TemplateFile C:\PowerShell\Azure\101-storage-account-create\azuredeploy.json -Verbose

New-AzureRmResourceGroupDeployment -Name "CentOS" -ResourceGroupName "Dev-MD" -TemplateParameterFile C:\PowerShell\Azure\101-vm-centos\azuredeploy.parameters.json -TemplateFile C:\PowerShell\Azure\101-vm-centos\azuredeploy.json -Verbose

New-AzureRmResourceGroupDeployment -Name "Win-Web-1" -ResourceGroupName "Dev-MD" -TemplateParameterFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.parameters.json -TemplateFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.json -vmName "test-md-web-1" -dnsLabelPrefix "test-md-web-1" -adminUsername "mdwinweb1suser" -Verbose

New-AzureRmResourceGroupDeployment -Name "Win-Web-2" -ResourceGroupName "Dev-MD" -TemplateParameterFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.parameters.json -TemplateFile C:\PowerShell\Azure\101-vm-Windows-Server\azuredeploy.json -vmName "test-md-web-2" -dnsLabelPrefix "test-md-web-2" -adminUsername "mdwinweb2suser" -Verbose




Remove-AzureRmResourceGroup -Name Dev-MD

#delete vms + assets...
$vmName = "test-md-centos"
$rgName = "PS-Test-RG"
$ddName = Get-AzureRmVM -Name $vmName -ResourceGroupName $rgName | Select-Object -ExpandProperty datadisknames

Remove-AzureRmVM -Name $vmName -ResourceGroupName $rgName

Get-AzureRmNetworkInterface -VirtualMachineScaleSetName