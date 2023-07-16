$addIdentifier = "WMI.PnpAddEvent"
$removeIdentifier = "WMI.PnpRemoveEvent"

$addAction = {
    $pnpEntity = $EventArgs.NewEvent.TargetInstance
    if ($pnpEntity.Caption -eq "Oculus Composite ADB Interface") {
        Write-Host "Device plugged in: $($pnpEntity.DeviceID)"
        
        $registryPath = "HKCU:\SOFTWARE\AMD\DVR"
        $registryName = "DesktopRecordingEnabled"
        $registryValue = 0x00000000
        Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue
    }
}

$addQuery = "SELECT * FROM __instancecreationevent WITHIN 5 WHERE targetinstance isa 'Win32_PnPEntity'"

$removeAction = {
    $pnpEntity = $EventArgs.NewEvent.TargetInstance
    if ($pnpEntity.Caption -eq "Oculus Composite ADB Interface") {        
        Write-Host "Device unplugged: $($pnpEntity.DeviceID)"
        
        $registryPath = "HKCU:\SOFTWARE\AMD\DVR"
        $registryName = "DesktopRecordingEnabled"
        $registryValue = 0x00000001
        Set-ItemProperty -Path $registryPath -Name $registryName -Value $registryValue
    }
}

$removeQuery = "SELECT * FROM __instancedeletionevent WITHIN 5 WHERE targetinstance isa 'Win32_PnPEntity'"

$addEventArgs = @{
    Query            = $addQuery
    SourceIdentifier = $addIdentifier
    SupportEvent     = $true
    Action           = $addAction
}

$removeEventArgs = @{
    Query            = $removeQuery
    SourceIdentifier = $removeIdentifier
    SupportEvent     = $true
    Action           = $removeAction
}

Register-WmiEvent @addEventArgs
Register-WmiEvent @removeEventArgs

while ($true) {
    Start-Sleep -Seconds 1
}
