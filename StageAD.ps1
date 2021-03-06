#Requires -version 5.1
#requires -module ActiveDirectory

<#
StageAD.ps1
stage Nano server computer accounts in Active Directory

I have found that if I create a domain computer account ahead of time
all I have to do is specify the domain and use the ReuseDomainNode parameter.
This avoids the need to mess around with blobs.
#>

1..20 | foreach {
    $name = "N-SRV$_"
Try {
    Get-ADComputer -Identity $name -ErrorAction Stop
    Write-host "AD account for $Name already exists" -ForegroundColor Magenta
}
Catch {
    Write-Host "Creating AD Account for $Name" -ForegroundColor Green
    New-ADComputer -Name $Name
}

}