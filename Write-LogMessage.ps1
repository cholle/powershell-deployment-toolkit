# Write-LogMessage.ps1
# Write log messages with formatting and severity levels

param(
    [Parameter(Mandatory=$true)]
    [string]$Message,
    
    [Parameter(Mandatory=$false)]
    [ValidateSet("Info", "Warning", "Error", "Success")]
    [string]$Severity = "Info",
    
    [Parameter(Mandatory=$false)]
    [string]$LogFile = "C:\Logs\deployment.log"
)

<#
.SYNOPSIS
    Write log messages with formatting and severity levels

.DESCRIPTION
    Writes messages to both console and file with timestamps and severity levels.
    Creates log directory if it doesn't exist. Uses approved PowerShell verb 'Write-'.

.PARAMETER Message
    The message to log

.PARAMETER Severity
    Log severity level: Info, Warning, Error, or Success

.PARAMETER LogFile
    Path to log file. Defaults to C:\Logs\deployment.log

.EXAMPLE
    Write-LogMessage "Device initialization started" "Info"
    Write-LogMessage "Warning: Device offline" "Warning"
    Write-LogMessage "Initialization failed" "Error"
    Write-LogMessage "All devices ready" "Success"
#>

function Write-LogMessage {
    param(
        [string]$Message,
        [string]$Severity = "Info",
        [string]$LogFile = "C:\Logs\deployment.log"
    )
    
    # Ensure log directory exists
    $logDir = Split-Path $LogFile -Parent
    if (-not (Test-Path $logDir)) {
        New-Item -ItemType Directory -Path $logDir -Force | Out-Null
    }
    
    # Format timestamp
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    
    # Create log entry
    $logEntry = "[$timestamp] [$Severity] $Message"
    
    # Color output based on severity
    $color = switch ($Severity) {
        "Error" { "Red" }
        "Warning" { "Yellow" }
        "Success" { "Green" }
        default { "White" }
    }
    
    # Write to console
    Write-Host $logEntry -ForegroundColor $color
    
    # Write to file
    Add-Content -Path $LogFile -Value $logEntry -ErrorAction SilentlyContinue
}

# Main execution
Write-LogMessage $Message $Severity $LogFile
