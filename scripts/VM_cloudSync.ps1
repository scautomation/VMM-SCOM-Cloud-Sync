<#
Sync SCVMM Cloud VMs to SCOM groups
Purpose of the script is to take Virtual Machines in VMM Clouds and put them in SCOM groups for maintenance mode and reporting. Also to add to DPM Protection groups.

this script uses VMM powershell module and Tao Yang's OpsMgr custom powershell module for SCOM 2012 r2+

by Billy York @scautomation
www.systemcenterautomation.com
#>

# Set VMM and SCOM Servers
$vmmserver = 'your VMM Server'
$scomserver = 'your SCOM Server'
$mpname = "management pack"
$domain = "domain"

#Set VMM Cloud groups and SCOM Groups
$cloud1 = "Prod Cloud"
$cloud2 = "Non Prod Cloud"
$scomgroup1 = "Prod Cloud"
$scomgroup2 = "Non Prod Cloud"

#declare full group names for creation
$scomgroup1Full = "Prod.Cloud"
$scomgroup2Full = "Non.Prod.Cloud"

#Import VMM, OpsMgr & OpsMgrSDK modules
Import-OpsMgrSDK
Import-Module virtualmachinemanager
Import-Module operationsmanager

#Get VMs from VMM Server, with Name, Cloud
$vms = Get-SCVirtualMachine -VMMServer $vmmserver | Select-Object name, cloud

foreach($vm in $vms)
{
    $computer = $vm.name
    $cloud = $vm.Cloud
    $cloudname = $cloud.name

    
    #If the VM is not assigned a cloud put in outfile
    if($cloudname -eq $null)
    {
           $computer | out-file c:\temp\nocloudname.txt -Append
     }

  
#sort Cloud1 VM into Cloud 1 SCOM Group
    if($cloudname -eq $cloud1)
    {
       #get scom group
       $verify = get-scomgroup -displayname $scomgroup1
     
       #if the scom group does not exist, create it, sleep, then add the VM to it.
        if($verify -eq $null)
            {
             $create = new-omcomputergroup -sdk $scomserver -MPname $mpname -computergroupname $scomgroup1Full -computergroupdisplayname $scomgroup1
             start-sleep -Seconds 360
             $groupadd = New-OMComputerGroupExplicitMember -SDK $scomserver -GroupName $create.fullname -ComputerPrincipalName $computer
            } Else {$groupadd = New-OMComputerGroupExplicitMember -SDK $scomserver -GroupName $verify.fullname -ComputerPrincipalName $computer}
    }

#sort Cloud2 VM into Cloud 2 SCOM Group
    if($cloudname -eq $cloud2)
    {
        #get scom group 
        $verify = get-scomgroup -displayname $scomgroup2
     
        #if the scom group does not exist, create it, sleep to allow DB propagation, then add the VM to it.
        if($verify -eq $null)
            {
             $create = new-omcomputergroup -sdk $scomserver -MPname $mpname -computergroupname $scomgroup2full -computergroupdisplayname $scomgroup2
             start-sleep -Seconds 360
             $groupadd = New-OMComputerGroupExplicitMember -SDK $scomserver -GroupName $create.fullname -ComputerPrincipalName $computer
            } Else {$groupadd = New-OMComputerGroupExplicitMember -SDK $scomserver -GroupName $verify.fullname -ComputerPrincipalName $computer}
            
    }
    
}
