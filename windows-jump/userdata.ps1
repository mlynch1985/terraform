<powershell>
try {
	New-EventLog -Source "UserData" -Logname Application

	$InstanceMetaData = Get-EC2InstanceMetadata -Category IdentityDocument | ConvertFrom-Json
	$InstanceID = $InstanceMetaData.instanceId
	$Region = $InstanceMetaData.region
	$InstanceTags = Get-EC2Tag -Region $Region -Filter @{ Name="resource-id"; Values="$InstanceID" }
	foreach ($tag in $InstanceTags) { Set-Variable -Name $tag.Key -Value $tag.Value; } ## namespace
    $MsiExecPath = "C:\Windows\System32\msiexec.exe"
	$AgentSource = "https://s3.$($Region).amazonaws.com/amazoncloudwatch-agent-$($Region)/windows/amd64/latest/amazon-cloudwatch-agent.msi"
    $AgentDestination = "C:\amazon-cloudwatch-agent.msi"
	$BucketName = "$namespace-mltemp"
	$ConfigSource = "CloudWatchConfigs/windows-amazon-cloudwatch-agent.json"
	$ConfigDestination = "C:\ProgramData\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent.json"

	Set-DefaultAWSRegion -Region $Region

    (New-Object System.Net.WebClient).DownloadFile($AgentSource , $AgentDestination)
    Start-Process -FilePath $MsiExecPath -ArgumentList "/i $AgentDestination /qn /L*V C:\cloudwatchagent-log.txt" -Wait -NoNewWindow
	Copy-S3Object -BucketName $BucketName -Key $ConfigSource -LocalFile $ConfigDestination
	& "C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1" -Action fetch-config -Mode ec2 -ConfigLocation file:$ConfigDestination -Start
}
catch {
	$stacktrace = $_.ScriptStackTrace
	Add-Content -Path C:\userdata.log -Value "ERROR in user data script"
	Add-Content -Path C:\userdata.log -Value $stacktrace
	Write-EventLog -LogName "Application" -Source "UserData" -EventID 500 -EntryType Error -Message "Unhandled Error in user data. `nstack_trace=${stacktrace}"
}

</powershell>
<persist>false</persist>
