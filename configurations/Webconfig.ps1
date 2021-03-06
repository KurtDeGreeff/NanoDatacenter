#Requires -version 5.1

#This configuration has issues with Nano

Configuration NanoWeb {

Param([string[]]$Computername)

Import-DscResource -Module PSDesiredStateConfiguration
Import-DscResource -Module xWebAdministration 

Node $Computername {


    # Install the IIS role THIS SHOULD ALREADY BE PRESENT
    WindowsFeature IIS
    {
        Ensure          = 'Present'
        Name            = 'Web-Server'
    }

<#
    # Install the ASP .NET 4.5 role NOT AVAILABLE ON NANO
    WindowsFeature AspNet45
    {
        Ensure          = 'Present'
        Name            = 'Web-Asp-Net45'
    }
#>
    # Stop the default website
    xWebsite DefaultSite 
    {
        Ensure          = 'Present'
        Name            = 'Default Web Site'
        State           = 'Stopped'
        PhysicalPath    = 'C:\inetpub\wwwroot'
        DependsOn       = '[WindowsFeature]IIS'
    }

    # Copy the website content
    File WebContent
    {
        Ensure          = 'Present'
        SourcePath      = '\\chi-fp02\it\bakerywebSite'
        DestinationPath = "c:\inetpub\wwwroot\"
        Recurse         = $true
        Type            = 'Directory'

        #We'll try anyway to see what happens
        # DependsOn       = '[WindowsFeature]AspNet45'
    }       

    # Create the new Website
    xWebsite NewWebsite
    {
        Ensure          = 'Present'
        Name            = 'Bakery'
        State           = 'Started'
        PhysicalPath    = "c:\inetpub\wwwroot\"
        BindingInfo     = @(MSFT_xWebBindingInformation
                            {
                            Protocol   = "HTTP"
                            Port       = 80
                            #Hostname   = "Bakery.globomantics.local"
                          }
                          )
        DependsOn       = '[File]WebContent'
    }
  
LocalConfigurationManager {
    RebootNodeIfNeeded = $True
    ConfigurationMode = 'ApplyAndAutoCorrect'
    ActionAfterReboot = 'ContinueConfiguration'
    AllowModuleOverwrite =  $True
}
}

}

Configuration StandardWeb {

Param([string[]]$Computername)

Import-DscResource -Module PSDesiredStateConfiguration
Import-DscResource -Module xWebAdministration 

Node $Computername {

    # Install the IIS role 
    WindowsFeature IIS
    {
        Ensure          = 'Present'
        Name            = 'Web-Server'
    }

    # Install the ASP .NET 4.5 role 
    WindowsFeature AspNet45
    {
        Ensure          = 'Present'
        Name            = 'Web-Asp-Net45'
    }

    # Stop the default website
    xWebsite DefaultSite 
    {
        Ensure          = 'Present'
        Name            = 'Default Web Site'
        State           = 'Stopped'
        PhysicalPath    = 'C:\inetpub\wwwroot'
        DependsOn       = '[WindowsFeature]IIS'
    }

    # Copy the website content
    File WebContent
    {
        Ensure          = 'Present'
        SourcePath      = '\\chi-fp02\it\bakerywebSite'
        DestinationPath = "c:\inetpub\wwwroot\"
        Recurse         = $true
        Type            = 'Directory'
        DependsOn       = '[WindowsFeature]AspNet45'
    }       

    # Create the new Website
    xWebsite NewWebsite
    {
        Ensure          = 'Present'
        Name            = 'Bakery'
        State           = 'Started'
        PhysicalPath    = "c:\inetpub\wwwroot\"
        BindingInfo     = @(MSFT_xWebBindingInformation
                            {
                            Protocol   = "HTTP"
                            Port       = 80
                           # Hostname   = "Bakery.globomantics.local"
                          }
                          )
        DependsOn       = '[File]WebContent'
    }

LocalConfigurationManager {
    RebootNodeIfNeeded = $True
    ConfigurationMode = 'ApplyAndAutoCorrect'
    ActionAfterReboot = 'ContinueConfiguration'
    AllowModuleOverwrite =  $True
}
}


}


