# Provision-Devices.ps1
# Automated device provisioning with Windows image deployment

param(
    [Parameter(Mandatory=$true)]
    [string]$DeviceList,
    
    [Parameter(Mandatory=$true)]
    [string]$ImagePath,
    
    [Parameter(Mandatory=$false)]
    [int]$TimeoutSeconds = 3600,
    
    [Parameter(Mandatory=$false)]
    [string]$LogFile = "C:\Logs\provisioning.log"
)

<#
.SYNOPSIS
    Provisions devices with a Windows image

.DESCRIPTION
    Reads device list from CSV, validates devices, and deploys Windows image
    to each device. Includes error handling and logging.

.PARAMETER DeviceList
    Path to CSV file with device list (columns: DeviceName, MAC, IP)

.PARAMETER ImagePath
    Path to Windows image file (.wim)

.PARAMETER TimeoutSeconds
    Timeout for each device deployment (default: 3600)

.PARAMETER LogFile
    Path to log file

.EXAMPLE
    .\Provision-Devices.ps1 -DeviceList "C:\devices.csv" -ImagePath "C:\images\build.wim"
#>

# Source logging utility
$scriptDir = Split-Path $MyInvocation.MyCommand.Path
. "$scriptDir\Log-Message.ps1"

function Test-DeviceAvailability {
    param([string]$DeviceIP)
    
    try {
        $ping = Test-Connection -ComputerName $DeviceIP -Count 1 -Quiet -ErrorAction Stop
        return $ping
    } catch {
        return $false
    }
}

function Deploy-ImageToDevice {
    param(
        [string]$DeviceIP,
        [string]$DeviceName,
        [string]$ImagePath,
        [int]$TimeoutSeconds
    )
    
    Log-Message "Starting deployment to $DeviceName ($DeviceIP)" "Info" $LogFile
    
    try {
        # Validate image exists
        if (-not (Test-Path $ImagePath)) {
            throw "Image file not found: $ImagePath"
        }
        
        # Wait for device to be available
        $waitTime = 0
        while (-not (Test-DeviceAvailability -DeviceIP $DeviceIP) -and $waitTime -lt 300) {
            Log-Message "Waiting for device $DeviceName to become available..." "Warning" $LogFile
            Start-Sleep -Seconds 10
            $waitTime += 10
        }
        
        if ($waitTime -ge 300) {
            throw "Device $DeviceName did not become available within timeout"
        }
        
        # Deploy image (this is a simplified example)
        # In production, you'd use Windows Deployment Services (WDS) or similar
        Log-Message "Deploying image to $DeviceName..." "Info" $LogFile
        
        # Create deployment job
        $deploymentParams = @{
            ComputerName = $DeviceIP
            ScriptBlock = {
                param($imagePath)
                # Simplified deployment logic
                # In real scenario: use dism.exe or WDS API
                Write-Output "Deploying $imagePath"
            }
            ArgumentList = $ImagePath
            AsJob = $true
            JobName = "Deploy-$DeviceName"
        }
        
        $job = Invoke-Command @deploymentParams
        
        # Wait for job completion
        $jobResult = Wait-Job -Job $job -Timeout $TimeoutSeconds
        
        if ($jobResult.State -eq "Completed") {
            Log-Message "Image deployed successfully to $DeviceName" "Success" $LogFile
            return $true
        } else {
            throw "Deployment job timed out or failed"
        }
    } catch {
        Log-Message "Failed to deploy to $DeviceName : $_" "Error" $LogFile
        return $false
    }
}

function Start-DeviceProvisioning {
    param(
        [string]$DeviceList,
        [string]$ImagePath,
        [int]$TimeoutSeconds,
        [string]$LogFile
    )
    
    Log-Message "Beginning device provisioning" "Info" $LogFile
    Log-Message "Device List: $DeviceList" "Info" $LogFile
    Log-Message "Image Path: $ImagePath" "Info" $LogFile
    
    try {
        # Validate inputs
        if (-not (Test-Path $DeviceList)) {
            throw "Device list not found: $DeviceList"
        }
        
        if (-not (Test-Path $ImagePath)) {
            throw "Image file not found: $ImagePath"
        }
        
        # Read device list
        $devices = Import-Csv -Path $DeviceList
        Log-Message "Loaded $($devices.Count) devices from list" "Info" $LogFile
        
        # Provision each device
        $successCount = 0
        $failureCount = 0
        
        foreach ($device in $devices) {
            $result = Deploy-ImageToDevice `
                -DeviceIP $device.IP `
                -DeviceName $device.DeviceName `
                -ImagePath $ImagePath `
                -TimeoutSeconds $TimeoutSeconds
            
            if ($result) {
                $successCount++
            } else {
                $failureCount++
            }
        }
        
        # Log summary
        Log-Message "Provisioning complete: $successCount successful, $failureCount failed" "Info" $LogFile
        
        return @{
            Success = $successCount
            Failed = $failureCount
            Total = $devices.Count
        }
        
    } catch {
        Log-Message "Critical error during provisioning: $_" "Error" $LogFile
        throw
    }
}

# Main execution
Start-DeviceProvisioning -DeviceList $DeviceList -ImagePath $ImagePath `
    -TimeoutSeconds $TimeoutSeconds -LogFile $LogFile
