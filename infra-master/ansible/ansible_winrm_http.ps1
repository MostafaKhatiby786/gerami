### Open PowerShell as administrator and copy and paster this script in it

# Changing the network connection type to private
Set-NetConnectionProfile -NetworkCategory Private

# Enable PowerShell remoting
Enable-PSRemoting -SkipNetworkProfileCheck -Force

# Create ansible user and make it administrators
net user /add ansible Ansibl3_P@3s
net localgroup administrators ansible /add

# Set WinRM service startup type to automatic
Set-Service WinRM -StartupType 'Automatic'

# Configure WinRM Service
Set-Item -Path 'WSMan:\localhost\Service\AllowUnencrypted' -Value $true
Set-Item -Path 'WSMan:\localhost\Service\Auth\Basic' -Value $true

# Create a firewall rule to allow WinRM HTTP inbound
New-NetFirewallRule -DisplayName "Allow WinRM HTTP" -Direction Inbound -LocalPort 5985 -Protocol TCP -Action Allow

# Restart the WinRM service
Restart-Service WinRM

# List the WinRM listeners
winrm enumerate winrm/config/Listener
