#import VMM, OpsMgr and OpsMgrSDK Powershell Modules
import-module virtualmachinemanager
import-module operationsmanager
Import-OpsMgrSDK

#VMM, SCOM servers and Domain. Change to your environment
$vmmserver = 'vmm01.sandlot.dom'
$scomserver = 'om01.sandlot.dom'
$domain = 'sandlot.dom'
$mp = ""

#get all VMM Hosts selecting their names and clusternames
$hosts = get-vmhost -VMMServer $vmmserver | Select-Object computername,hostcluster,VMHostGroup

#New-OMManagementPack -SDK $scomserver -DisplayName "Custom Cloud Groups" -Name "custom.cloud.groups"

$mp = get-scommanagementpack -Name $mp


foreach($vmhost in $hosts)
{
    $computer = $vmhost.computername
    $cluster = $vmhost.hostcluster
    $hostgroup = $vmhost.vmhostgroup

    #VMM puts "all hosts" in front of each host group
    $hostgroup = $hostgroup -replace "All Hosts\\",""

 
    #I used this with 3 different host clusters, your needs may vary.       
    $verify = get-scomgroup -displayname $hostgroup
     
        if($verify -eq $null)
            {
             $create = new-omcomputergroup -sdk $scomserver -MPname $mp.Name -computergroupname "HyperVHost.$hostgroup" -computergroupdisplayname "HyperVHost Group $hostgroup"
             start-sleep -Seconds 400
             $groupadd = New-OMComputerGroupExplicitMember -SDK $scomserver -GroupName $verify.FullName -ComputerPrincipalName "$computer.$domain" -Verbose -Debug
            } Else {$groupadd = New-OMComputerGroupExplicitMember -SDK $scomserver -GroupName $verify.FullName -ComputerPrincipalName "$computer.$domain"}
   
    }


    
