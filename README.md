# PowerShell Deployment Toolkit

A collection of practical PowerShell scripts for Windows infrastructure automation, device provisioning, deployment, and testing. These are production-ready patterns used in enterprise environments.

## Scripts Included

### Device & Deployment Management
- `Initialize-Devices.ps1` - Automated device provisioning and configuration
- `Invoke-WindowsImageDeployment.ps1` - Deploy Windows images to target devices
- `Get-DeviceStatus.ps1` - Query device status and readiness

### Image Management
- `Mount-WindowsImage.ps1` - Mount/dismount Windows image files (.wim)
- `Add-ImageDriver.ps1` - Add device drivers to Windows images
- `Test-ImageIntegrity.ps1` - Validate image health and completeness

### Infrastructure Automation
- `New-ADUserConfiguration.ps1` - Create and configure Active Directory users
- `New-FileShare.ps1` - Create and manage network file shares
- `Initialize-TestLabEnvironment.ps1` - Configure test lab infrastructure

### Validation & Testing
- `Test-DeviceConnectivity.ps1` - Test network and RDP connectivity
- `Test-Drivers.ps1` - Validate driver packages before deployment
- `Invoke-DeploymentValidation.ps1` - Run post-deployment validation tests

### Utilities
- `Write-LogMessage.ps1` - Centralized logging utility
- `Get-ScriptConfiguration.ps1` - Load configuration from JSON files
- `Invoke-RetryLogic.ps1` - Retry with exponential backoff pattern

## Usage

### Basic Example
```powershell
# Import the toolkit
. ".\Scripts\Write-LogMessage.ps1"
. ".\Scripts\Initialize-Devices.ps1"

# Initialize devices from CSV
Initialize-Devices -DeviceList ".\devices.csv" -ImagePath "C:\images\build.wim"
```

### Advanced Example
```powershell
# Configure environment
$config = Get-ScriptConfiguration -ConfigFile ".\config.json"

# Initialize with error handling
try {
    Invoke-RetryLogic -ScriptBlock {
        Initialize-Devices -DeviceList $config.DeviceList -ImagePath $config.ImagePath
    } -MaxRetries 3
    Write-LogMessage "Device initialization completed successfully" "Success"
} catch {
    Write-LogMessage "Device initialization failed: $_" "Error"
}
```

## Key Features

- **Error Handling** - All scripts include proper error handling and logging
- **Retry Logic** - Built-in retry mechanisms for network/timing-dependent operations
- **Configuration** - JSON-based configuration for easy customization
- **Logging** - Centralized logging with timestamps and severity levels
- **Documentation** - Comments and examples in each script

## Requirements

- PowerShell 5.0+
- Administrator privileges (for most operations)
- Windows Server 2016+ or Windows 10+
- For image operations: Windows Assessment and Deployment Kit (ADK)

## Configuration

Edit `config.json` with your environment-specific settings:
```json
{
  "LogPath": "C:\Logs\deployment.log",
  "ImagePath": "C:\Images\build.wim",
  "DeviceList": "C:\config\devices.csv",
  "DeploymentTimeout": 3600
}
```

## Notes

- All scripts use `-ErrorAction Stop` by default for safety
- Dry-run mode available on most scripts (add `-WhatIf` flag)
- Logging to both file and console by default
- Designed for unattended execution in CI/CD pipelines

## Contributing

These scripts are examples of infrastructure automation patterns. Adapt for your specific environment and requirements.
