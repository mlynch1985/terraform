<powershell>
try {
    # Setup Windows Event Logs
	New-EventLog -Source "UserData" -Logname Application

    if (Get-PSDrive E -ErrorAction SilentlyContinue) {
        Write-Host "E: Drive is already mounted"
    } else {
        try {
            Get-Disk |
            Where-Object PartitionStyle -Eq "RAW" |
            Initialize-Disk -PartitionStyle GPT -PassThru |
            New-Partition -DriveLetter E -UseMaximumSize |
            Format-Volume
        }
        catch {
            Write-Host "A second drive doesn't exist.  Can't mount E:\ drive"
        }
    }

    # Query the AWS Metadata service for information about the current instance
    $INSTANCE_METADATA = Get-EC2InstanceMetadata -Category IdentityDocument | ConvertFrom-Json
	$INSTANCE_ID = $INSTANCE_METADATA.instanceId
	$REGION = $INSTANCE_METADATA.region
    $EC2_TAGS = Get-EC2Tag -Filter @{Name="resource-type";Value="instance"}, @{Name="resource-id";Value="$($INSTANCE_ID)"}
    foreach ($tag in $EC2_TAGS) { Set-Variable -Name $($tag.Key).ToUpper() -Value $tag.Value; }

    # Set other values for this session
    $MSI_EXEC_PATH = "C:\Windows\System32\msiexec.exe"
    $AGENT_SOURCE = "https://s3.$($REGION).amazonaws.com/amazoncloudwatch-agent-$($REGION)/windows/amd64/latest/amazon-cloudwatch-agent.msi"
    $AGENT_DESTINATION = "C:\amazon-cloudwatch-agent.msi"
    $AGENT_BINARY = "C:\Program Files\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent-ctl.ps1"
    $CWA_CONFIG_SOURCE = (Get-SSMParameterValue -Name "/$($NAMESPACE)/$($COMPONENT)/cwa/windows" -Region $REGION).Parameters.Value
    $CWA_CONFIG_DESTINATION = "C:\ProgramData\Amazon\AmazonCloudWatchAgent\amazon-cloudwatch-agent.json"

    # Download the latest version of the CloudWatch Agent for Windows
    (New-Object System.Net.WebClient).DownloadFile($AGENT_SOURCE, $AGENT_DESTINATION)

    # Install the CloudWatch Agent
    Start-Process -FilePath $MSI_EXEC_PATH -ArgumentList "/i $AGENT_DESTINATION /qn /L*V C:\cloudwatchagent-log.txt" -Wait -NoNewWindow

    # Setup the CloudWatch Agent Config
    $CWA_CONFIG_SOURCE | Set-Content -Path $CWA_CONFIG_DESTINATION
    (Get-Content -Path $CWA_CONFIG_DESTINATION -Raw) -Replace "NAME_SPACE", "$($NAMESPACE)_$($COMPONENT)" | Set-Content -Path $CWA_CONFIG_DESTINATION

    # Start the CloudWatch Agent
    & $AGENT_BINARY -Action fetch-config -Mode ec2 -ConfigLocation file:$CWA_CONFIG_DESTINATION -Start

    # Clean up the CloudWatch Agent installer
    Remove-Item -Path $AGENT_DESTINATION -Force

    <# INSERT CUSTOM CODE HERE #>
    Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools
}
catch {
    # Log any failures to the Windows Event Log
	$stacktrace = $_.ScriptStackTrace
	Add-Content -Path C:\userdata.log -Value "ERROR in user data script"
	Add-Content -Path C:\userdata.log -Value $stacktrace
	Write-EventLog -LogName "Application" -Source "UserData" -EventID 500 -EntryType Error -Message "Unhandled Error in user data. `nstack_trace=${stacktrace}"
}

</powershell>
<persist>false</persist>
