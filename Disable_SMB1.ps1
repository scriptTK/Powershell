$SMBHosts = Get-Content C:\TEMP\SMB1_Hosts.txt

foreach ($host_name in $SMBHosts) {
try {
	Invoke-Command -ComputerName $host_name -ScriptBlock { Disable-WindowsOptionalFeature -Online -FeatureName "SMB1Protocol" -NoRestart ;   Restart-Computer -Force }
	}
catch {
Write-Output "$host_name - $($_.Exception.Message)"
	}
}
