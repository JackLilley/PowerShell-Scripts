$rgname="your resource group name"
$LocName="location where you deploy VM"
#$avset="availabilityset name"
$osdiskname="existing OS disk by which you deploy VM"
$vmsize="Standard_F1"
$vmname="VM name"
#$AvailabilitySet = Get-AzureRmAvailabilitySet -ResourceGroupName $rgname -Name $avset
#$vm=New-AzVMConfig -VMName $vmname -VMSize $vmsize -AvailabilitySetID $AvailabilitySet.Id
$vm=New-AzVMConfig -VMName $VMName -VMSize $VMSize
Set-AzVMPlan -VM $vm -Publisher sophos-Product sophos-xg -Name "byol"
$netrgname="resource group where NIC is present"
$nicName="name of existing NIC"
$nic=Get-AzNetworkInterface -Name $nicName -ResourceGroupName $rgname
$nicId=$nic.Id;
$vm=Add-AzVMNetworkInterface -VM $vm -Id $nicId -Primary
$disk = Get-AzDisk -ResourceGroupName $rgname -Name $osdiskname
$vm=Set-AzVMOSDisk -VM $vm -ManagedDiskId $disk.Id -CreateOption Attach -Linux
New-AzVM -ResourceGroupName $rgname -Location $LocName -VM $vm