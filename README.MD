![scom scvmm powershell logo](images/scvmmscom_twitter.png)
# Sync SCVMM Virtual Machines & Hosts from SCVMM Clouds to Operations Manager Groups

These script will show you how to create SCOM groups for each of your VMs and Hosts per Cloud/Clusters in SCVMM

You'll need:
- Powershell Read Rights to VMM (Remote rights if using it from a different PC)
- At least Author Rights to SCOM as the script will create SCOM Groups and add VMs to them
- The OpsMgr SDK found here https://github.com/tyconsulting/OpsMgr-SDK-Scripts/blob/master/README.md
- The VMM, OpsMgr and OpsMgrSDK Powershell Modules all installed on the machine running the script

I typically run these scripts from a Operations Manager Management Server, as VMM has much better support for remote commands. The OpsMgrSDK doesn't have any support for remote commands. You will need to use invoke-command to use commands remotely

These scripts uses elements of my SCOM Group creation found here https://www.systemcenterautomation.com/2018/01/automate-scom-group-creation/ 

## Virtual Machine sync
vm_cloudsync.ps1

## Host Sync
Host_CloudSync.ps1