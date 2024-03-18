#Create an array containing the list of servers to be updated:
$Servers = Get-Content C:\TEMP\SpecEx.txt

# Iterate through the array created above:
foreach ($server in $Servers) 
{
Invoke-Command -ComputerName $server -ScriptBlock {
	# Write to the screen so that the user knows which server is being worked on:
	Write-Host "Now working on $using:server"
	# If backup file exists, delete it - also record (& display) the return code for this step:
	$FileName = "C:\MemMgmt.reg"
	if (Test-Path $FileName) {
		Write-Host "Deleting backup file found on this system..."
		Remove-Item $FileName
	}
	$LEC = $LASTEXITCODE
	Write-Host "Exit code is"
	Write-Host $LEC
	# Lines below are just there to provide visual separation between output from different systems
	Write-Host " "
	Write-Host "                        << >>                        "
	Write-Host "     =============== <<<< + >>>> ===============       "
	Write-Host "                        << >>                        "
	Write-Host " "
    }
}