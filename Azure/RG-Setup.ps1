Import-Module Azure
Login-AzureRmAccount

#Set up resources for virtual machines

# set up resource group
$rgName = ""
$rgLocation = "North Europe"
$tag = @{Name="Name";Value="Value"}

New-AzureRmResourceGroup -Name $rgName -Location $rgLocation -Tag $tag

# set up virtual network
$rgName="PS-Test-RG"
$locName="North Europe"
$frontendSubnet=New-AzureRmVirtualNetworkSubnetConfig -Name frontendSubnet -AddressPrefix 10.0.1.0/24
$backendSubnet=New-AzureRmVirtualNetworkSubnetConfig -Name backendSubnet -AddressPrefix 10.0.2.0/24
New-AzureRmVirtualNetwork -Name TestNet -ResourceGroupName $rgName -Location $locName -AddressPrefix 10.0.0.0/16 -Subnet $frontendSubnet,$backendSubnet

# set up storage account for resource group

# Test storage account name with: Test-AzureName -Storage <Proposed storage account name>
$rgName="PS-Test-RG"
$locName="North Europe"
#lowercase and numbers only for the name
$saName="psteststorageaccount"
#$saType="<storage account type, specify one: Standard_LRS, Standard_GRS, Standard_RAGRS, or Premium_LRS>"
$saType="Standard_GRS"
$saTag = @{Name="PS-Test";Value="Storage"}
New-AzureRmStorageAccount -Name $saName -ResourceGroupName $rgName –Type $saType -Location $locName -Tags $saTag

#Domain name
$domName="pstest"
$loc="northeurope"#"<short name of an Azure location, for example, for West US, the short name is westus>"
Test-AzureRmDnsAvailability -DomainQualifiedName $domName -Location $loc #true means it is globally unique

#Availability Set
$avName="PS-Test-Availability-Set"
$rgName="PS-Test-RG"
$locName="North Europe"
New-AzureRmAvailabilitySet –Name $avName –ResourceGroupName $rgName -Location $locName 


# set up virtual machine
$resourceGroupName = "PS-Test-RG"
$locationName = "North Europe"
$storageAccountName = "psteststorageaccount"

#Get subnets in the virtual network
$vnetName="Test-24-Network-PS"
Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $rgName | Select Subnets

$subnetIndex=0 
$vnet=Get-AzureRmVirtualNetwork -Name $vnetName -ResourceGroupName $resourceGroupName

#Create a NIC
$nicName="ps-md-dc-1-nic"
$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $resourceGroupName -Location $locationName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $resourceGroupName -Location $locationName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id

#or create a NIC with a DNS domain name label
$nicName="<name of the NIC of the VM>"
$domName="<domain name label>"
$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -DomainNameLabel $domName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id

#or create a NIC with a static internal IP address
$nicName="<name of the NIC of the VM>"
$staticIP="<available static IP address on the subnet>"
$pip = New-AzureRmPublicIpAddress -Name $nicName -ResourceGroupName $rgName -Location $locName -AllocationMethod Dynamic
$nic = New-AzureRmNetworkInterface -Name $nicName -ResourceGroupName $rgName -Location $locName -SubnetId $vnet.Subnets[$subnetIndex].Id -PublicIpAddressId $pip.Id -PrivateIpAddress $staticIP

#Create them VM object
#Determine the available size of the VM
$locName="North Europe"
Get-AzureRmVMSize -Location $locName | Select Name

$vmName="ps-md-dc-1"
$vmSize="Standard_A1"
$vm=New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize

#Create the VM object (if you want to add it to an availability set)
$avSet=Get-AzureRmAvailabilitySet –Name $avName –ResourceGroupName $rgName #run to check availability set names
$vmName="<VM name>"
$vmSize="<VM size string>"
$avName="<availability set name>"
$vm=New-AzureRmVMConfig -VMName $vmName -VMSize $vmSize -AvailabilitySetId $avset.Id

#Add an additional disk (if needed)
$diskSize=<size of the disk in GB>
$diskLabel="<the label on the disk>"
$diskName="<name identifier for the disk in Azure storage, such as 21050529-DISK02>"
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $rgName -Name $saName
$vhdURI=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $vmName + $diskName  + ".vhd"
Add-AzureRmVMDataDisk -VM $vm -Name $diskLabel -DiskSizeInGB $diskSize -VhdUri $vhdURI  -CreateOption empty

#Add the operating system image to the VM object
$pubName="MicrosoftWindowsServer"
$offerName="WindowsServer"
$skuName="2012-R2-Datacenter"
$cred=Get-Credential -Message "Type the name and password of the local administrator account."
$vm=Set-AzureRmVMOperatingSystem -VM $vm -Windows -ComputerName $vmName -Credential $cred -ProvisionVMAgent -EnableAutoUpdate
$vm=Set-AzureRmVMSourceImage -VM $vm -PublisherName $pubName -Offer $offerName -Skus $skuName -Version "latest"
$vm=Add-AzureRmVMNetworkInterface -VM $vm -Id $nic.Id


$diskName="ps-md-dc-1-os-disk"
$storageAcc=Get-AzureRmStorageAccount -ResourceGroupName $resourceGroupName -Name $storageAccountName
$osDiskUri=$storageAcc.PrimaryEndpoints.Blob.ToString() + "vhds/" + $diskName  + ".vhd"
$vm=Set-AzureRmVMOSDisk -VM $vm -Name $diskName -VhdUri $osDiskUri -CreateOption fromImage
New-AzureRmVM -ResourceGroupName $rgName -Location $locName -VM $vm 