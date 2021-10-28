Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
$CHOCO_TARGETS = @('googlechrome', 'notepadplusplus' , '7zip','tomcat', 'ant')
ForEach ($target in $CHOCO_TARGETS) {choco install $target /y}
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")
cd C:\
git clone https://github.com/SiemensMitsuhashi/DcTarget_Setup.git