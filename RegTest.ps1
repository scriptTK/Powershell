#Create an array containing the list of servers to be updated:
$Servers = Get-Content C:\TEMP\SpecEx.txt

# Create the variable to hold the credentials:
$Credentials = Get-Credential

# Iterate through the array created above:
foreach ($server in $Servers) 
{
Invoke-Command -ComputerName $server -ScriptBlock {
	# Write to the screen so that the user knows which server is being worked on:
	Write-Host " "
	Write-Host "Now working on $using:server"
	# Back up the registry key before changing anything so that we can always return to original state, also record (& display) the return code for this step:
	reg export 'HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' C:\MemMgmt.reg
	$LEC = $LASTEXITCODE
	Write-Host $LEC
	$FileName = "C:\MemMgmt.reg"
	if (Test-Path $FileName) {
		Write-Host "Backup of registry key was successful."
	}
	# If the return code is higher than zero, break out of the script without making any changes to the registry:
# If ($LEC -ge 1) { break } Else {
	if (Test-Path $FileName) {
	# The two lines below make the changes that resolve the "Speculative Execution" vulnerability:
	Invoke-Command -Credential $using:Credentials -ComputerName $using:server -ScriptBlock { reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverride /t REG_DWORD /d 72 /f }
	Invoke-Command -Credential $using:Credentials -ComputerName $using:server -ScriptBlock { reg add "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v FeatureSettingsOverrideMask /t REG_DWORD /d 3 /f }
	# Query the changed registry key & display the new values on the screen:
	Get-ItemPropertyValue -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name FeatureSettingsOverride
	Get-ItemPropertyValue -Path 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' -Name FeatureSettingsOverrideMask
	# Lines below provide visual separation between output from different systems:
	Write-Host "      ===========================================    "
	Write-Host "      =============== <<<< + >>>> ===============       "
	Write-Host "      ===========================================    "
	Write-Host " "
	}
   }
  }