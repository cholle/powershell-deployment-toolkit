# Invoke-RetryLogic.ps1
# Retry pattern with exponential backoff for network/timing-dependent operations

param(
    [Parameter(Mandatory=$true)]
    [scriptblock]$ScriptBlock,
    
    [Parameter(Mandatory=$false)]
    [int]$MaxRetries = 3,
    
    [Parameter(Mandatory=$false)]
    [int]$InitialDelaySeconds = 2
)

<#
.SYNOPSIS
    Execute a script block with automatic retry logic and exponential backoff

.DESCRIPTION
    Executes a script block and retries with exponential backoff if it fails.
    Useful for operations that might fail due to temporary network issues or timing.

.PARAMETER ScriptBlock
    The script block to execute

.PARAMETER MaxRetries
    Maximum number of retry attempts (default: 3)

.PARAMETER InitialDelaySeconds
    Initial delay between retries in seconds (default: 2)

.EXAMPLE
    Invoke-RetryLogic -ScriptBlock { Get-Item "\\server\share\file.txt" } -MaxRetries 3

.EXAMPLE
    Invoke-RetryLogic -ScriptBlock {
        Invoke-Command -ComputerName "device01" -ScriptBlock { whoami }
    } -MaxRetries 5 -InitialDelaySeconds 5
#>

function Invoke-RetryLogic {
    param(
        [scriptblock]$ScriptBlock,
        [int]$MaxRetries = 3,
        [int]$InitialDelaySeconds = 2
    )
    
    $attempt = 0
    $delay = $InitialDelaySeconds
    
    while ($attempt -le $MaxRetries) {
        try {
            $attempt++
            
            if ($attempt -gt 1) {
                Write-Host "Retry attempt $attempt of $($MaxRetries + 1)" -ForegroundColor Yellow
                Start-Sleep -Seconds $delay
            }
            
            # Execute the script block
            & $ScriptBlock
            return
            
        } catch {
            if ($attempt -gt $MaxRetries) {
                Write-Host "Failed after $MaxRetries retries" -ForegroundColor Red
                throw $_
            }
            
            Write-Host "Attempt $attempt failed: $($_.Exception.Message)" -ForegroundColor Yellow
            
            # Exponential backoff
            $delay = $delay * 2
            
            # Cap delay at 60 seconds
            if ($delay -gt 60) { $delay = 60 }
        }
    }
}

# Main execution
Invoke-RetryLogic -ScriptBlock $ScriptBlock -MaxRetries $MaxRetries -InitialDelaySeconds $InitialDelaySeconds
