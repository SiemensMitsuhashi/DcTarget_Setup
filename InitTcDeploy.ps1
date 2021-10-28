#Install Java and Unzip Deploymentcenter preferen dir on the premise
#complete configration deployment_center\install_config.properties

$title = "*** confirm ***"
$message = "Did you install java?"
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

# Consider expanding this logic to automate installation via Chocolatey
     if ((Get-Command "choco.exe" -ErrorAction SilentlyContinue) -eq $null) { 
         Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
     }


$CHOCO_TARGETS = @('googlechrome', 'notepadplusplus' , '7zip','tomcat', 'ant','git','gh')
     ForEach ($target in $CHOCO_TARGETS) {
         choco install $target /y
		}


$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

cd C:\

git clone https://github.com/SiemensMitsuhashi/DcTarget_Setup.git