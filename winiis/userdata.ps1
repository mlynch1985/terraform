<powershell>
try {
	New-EventLog -Source "UserData" -Logname Application

	$InstanceMetaData = Get-EC2InstanceMetadata -Category IdentityDocument | ConvertFrom-Json
	$InstanceID = $InstanceMetaData.instanceId
	$Region = $InstanceMetaData.region
    $MsiExecPath = "C:\Windows\System32\msiexec.exe"
	$AgentSource = "https://s3.$($Region).amazonaws.com/amazoncloudwatch-agent-$($Region)/windows/amd64/latest/amazon-cloudwatch-agent.msi"
	Set-DefaultAWSRegion -Region $Region

    $ConfigJson = (Get-SSMParameterValue -Name "sample-winiis-cloudwatchconfig").Parameters.Value
	$ConfigFile = "C:\ProgramData\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent.json"

    (New-Object System.Net.WebClient).DownloadFile($AgentSource , "C:\amazon-cloudwatch-agent.msi")
    Start-Process -FilePath $MsiExecPath -ArgumentList "/i C:\amazon-cloudwatch-agent.msi /qn /L*V C:\cloudwatchagent-log.txt" -Wait -NoNewWindow

	$ConfigJson | Set-Content -Path $ConfigFile 

	& "C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1" -Action fetch-config -Mode ec2 -ConfigLocation file:$ConfigFile -Start

	Install-WindowsFeature -Name Web-Server
}
catch {
	$stacktrace = $_.ScriptStackTrace
	Add-Content -Path C:\userdata.log -Value "ERROR in user data script"
	Add-Content -Path C:\userdata.log -Value $stacktrace
	Write-EventLog -LogName "Application" -Source "UserData" -EventID 500 -EntryType Error -Message "Unhandled Error in user data. `nstack_trace=${stacktrace}"
}

</powershell>
<persist>false</persist>
