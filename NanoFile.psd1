#Requires -version 5.0

<# 
Configuration Data for New-MyNanoImage

Keys can be any parameter from New-NanoServerImage that isn't 
specified as a parameter in the New-MyNanoImage function.

Base path is the folder with the Nanoserver.wim and the Packages folder
Diskpath is where to create the VHDX file

Required:
DeploymentType
Edition

You might want to add:
MaxSize
ServicePackages
UnattendPath
Development

#>

@{
BasePath = "D:\2016Media\NanoServer"
Edition = "standard"
DeploymentType = "Guest"
InterfaceNameorIndex = "Ethernet"
EnableEMS = $True
EnableRemoteManagementPort = $True
ipV4DNS = "172.16.30.203"
IPv4Subnet = "255.255.0.0"
IPv4Gateway = "172.16.10.254"
EMSPort = 1
EMSBaudRate = 115200
Defender = $True
Clustering = $false
Storage = $True
Containers = $False
Compute = $False
Package = @('Microsoft-NanoServer-Guest-Package','Microsoft-NanoServer-DSC-Package')
MaxSize = 8GB
}