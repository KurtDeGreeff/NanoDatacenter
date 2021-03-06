#Requires -version 5.1

<#
PowerShell      xDnsARecord               xDnsServer   
PowerShell      xDnsRecord                xDnsServer   
PowerShell      xDnsServerADZone          xDnsServer   
PowerShell      xDnsServerForwarder       xDnsServer   
PowerShell      xDnsServerPrimaryZone     xDnsServer   
PowerShell      xDnsServerSecondaryZone   xDnsServer   
PowerShell      xDnsServerZoneTransfer    xDnsServer   
#>

Configuration NanoDNS {

Param(
[string]$Computername,
[string]$JsonDNS
)

Import-DscResource -ModuleName PSDesiredStateConfiguration
Import-DscResource -ModuleName xDNSServer

Node $Computername {

xDnsServerSecondaryZone Globomantics {
    Name = 'globomantics.local'
    Ensure = 'present'
    MasterServers = '172.16.30.200','172.16.30.203'
}

xDnsServerPrimaryZone Summit {
    Name = 'Summit'
    Ensure = 'present'
}

(Get-Content $JsonDNS | convertfrom-json).Foreach({

    xDnsRecord "$($_.Name)" {
        DependsOn = '[xDnsServerPrimaryZone]Summit'
        Ensure = 'Present'
        Name = "$($_.Name)"
        Target = "$($_.Target)"
        Type = 'ARecord'
        zone = 'Summit'
    }
})

LocalConfigurationManager {
    RebootNodeIfNeeded = $True
    ConfigurationMode = 'ApplyAndAutoCorrect'
    ActionAfterReboot = 'ContinueConfiguration'
    AllowModuleOverwrite =  $True
}

}



}

