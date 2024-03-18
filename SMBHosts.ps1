$SMBHosts = Get-Content C:\TEMP\SMBHosts.txt

foreach ($host_name in $SMBHosts) {
try {
		Invoke-Command -ComputerName $host_name -ScriptBlock { hostname ; Get-SmbServerConfiguration | Select EnableSMB1Protocol }
	}
catch {
Write-Output "$host_name - $($_.Exception.Message)"
	}
}
