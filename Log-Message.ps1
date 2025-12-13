# Log-Message.ps1
# Centralized logging utility for consistent logging across all scripts

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
    Centralized logging function for infrastructure scripts

.DESCRIPTION
    Logs messages to both console and file with timestamps and severity levels.
    Creates log directory if it doesn't exist.

.PARAMETER Message
    The message to log

.PARAMETER Severity
    Log severity level: Info, Warning, Error, or Success

.PARAMETER LogFile
    Path to log file. Defaults to C:\Logs\deployment.log

.EXAMPLE
    Log-Message "Device provisioning started" "Info"
    Log-Message "Warning: Device offline" "Warning"
    Log-Message "Provisioning failed" "Error"
    Log-Message "All devices ready" "Success"
#>

function Log-Message {
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
Log-Message $Message $Severity $LogFile
