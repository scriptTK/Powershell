
#Create an array containing the list of servers to be updated:
$Servers = Get-Content C:\TEMP\NEThosts.txt

# Create the variable to hold the credentials:
$Credentials = Get-Credential

# Iterate through the array created above:
foreach ($server in $Servers) 
{
# 
# Actual "meat" of the script is just below:
Invoke-Command -ComputerName $server -Credential $Credentials -ScriptBlock {
	# Write to the screen so that the user knows which server is being worked on:
	Write-Host " "
	Write-Host "Now working on $using:server"
	# Test connection to remote system (usually commented out):
	# Test-WSMan -Computername $server
	Get-ADComputer -Identity $server -Properties DNSHostName,OperatingSystem,OperatingSystemVersion | Where-Object {($_.OperatingSystem -like "*Server*")} | Select DNSHostName,OperatingSystem,OperatingSystemVersion
	Write-Host " "
	Write-Host "Registry check output:"
	Write-Host " "
	$RegKey = Get-ChildItem -Path Registry::HKLM\SOFTWARE\Microsoft\"NET Framework Setup"\NDP\v4
	$RegKey
	# 
	$RegKey1 = dotnet --list-sdks
	$RegKey2 = dotnet --list-runtimes
	Write-Host " "
	Write-Host "Output of 1st 'dotnet' command:"
	$RegKey1
	# 
	Write-Host " "
	Write-Host "Output of 2nd 'dotnet' command:"
	$RegKey2
	Write-Host " "
	Write-Host "=================================================================================:"
	Write-Host " "
	}
}