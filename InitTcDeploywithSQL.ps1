#Install Java and Unzip Deploymentcenter preferen dir on the premise
#complete configration deployment_center\install_config.properties

$title = "*** confirm ***"
$message = "Did you install java and check to access Deploymentcenter Server?"
$objYes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes","Yes"
$objNo = New-Object System.Management.Automation.Host.ChoiceDescription "&No","No"
$objOptions = [System.Management.Automation.Host.ChoiceDescription[]]($objYes, $objNo)
$resultVal = $host.ui.PromptForChoice($title, $message, $objOptions, 1)
if ($resultVal -ne 0) { exit }

[System.Environment]::SetEnvironmentVariable("JRE_HOME", "$env:JAVA_HOME", "Machine")

net user "Administrator" "UGSplm99"

Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name "ConsentPromptBehaviorAdmin" -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name "PromptOnSecureDesktop" -Value 0
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System' -Name "EnableLUA" -Value 1

Set-NetFirewallProfile -Profile Private,Public -Enabled false

$Params = @{'Database' = 'master'}
$Params.Query = "EXEC xp_instance_regwrite N'HKEY_LOCAL_MACHINE','Software\Microsoft\MSSQLServer\MSSQLServer','LoginMode', REG_DWORD, 2"
invoke-sqlCmd @Params
$Params.Query = "ALTER LOGIN sa ENABLE"
invoke-sqlCmd @Params
$Params.Query = "ALTER LOGIN sa WITH PASSWORD = 'UGSplm99'"
invoke-sqlCmd @Params
Stop-Service SQLSERVERAGENT
Restart-Service MSSQLSERVER -Force
Start-Service SQLSERVERAGENT
