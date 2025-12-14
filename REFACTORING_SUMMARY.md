# PowerShell Verb Refactoring Summary

This document lists all the refactoring changes made to align with approved PowerShell verbs.

## Approved PowerShell Verbs Used

PowerShell has a standard set of verbs that should be used in function/cmdlet names. Using approved verbs makes code more professional and predictable.

Reference: https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-powershell-commands

## Changes Made

### Function Name Changes

| Old Name | New Name | Approved Verb |
|----------|----------|---------------|
| `Log-Message` | `Write-LogMessage` | Write |
| `Provision-Devices` | `Initialize-Devices` | Initialize |
| `Inject-Drivers` | `Add-ImageDriver` | Add |
| `Validate-Drivers` | `Test-Drivers` | Test |
| `Validate-ImageIntegrity` | `Test-ImageIntegrity` | Test |
| `Validate-ImageDrivers` | `Test-ImageDrivers` | Test |
| `Check-SystemIntegrity` | `Test-SystemIntegrity` | Test |
| `Deploy-WindowsImage` | `Invoke-WindowsImageDeployment` | Invoke |
| `Deploy-AndTest` | `Invoke-DeploymentAndValidation` | Invoke |
| `Collect-DeviceLogs` | `Get-DeviceLogs` | Get |
| `Unmount-WindowsImage` | `Dismount-WindowsImage` | Standard Windows verb |
| `Setup-TestLab` | `Initialize-TestLabEnvironment` | Initialize |
| `Configure-ADUser` | `New-ADUserConfiguration` | New |
| `Manage-FileShares` | `New-FileShare` / `Set-FileShare` / `Remove-FileShare` | New/Set/Remove |
| `Run-DeploymentTests` | `Invoke-DeploymentValidation` | Invoke |

### File Name Changes

| Old File Name | New File Name |
|---------------|---------------|
| `Log-Message.ps1` | `Write-LogMessage.ps1` |
| `Provision-Devices.ps1` | `Initialize-Devices.ps1` |
| `Inject-Drivers.ps1` | `Add-ImageDriver.ps1` |
| `Validate-Drivers.ps1` | `Test-Drivers.ps1` |
| `Validate-ImageIntegrity.ps1` | `Test-ImageIntegrity.ps1` |
| `Check-SystemIntegrity.ps1` | `Test-SystemIntegrity.ps1` |

## Updated Files

All YAML pipeline files have been updated to reference the new function names:
- `azure-pipelines.yml`
- `windows-image-deployment.yml`

All README files have been updated to show the new function names and examples.

## Why This Matters

1. **Professionalism** - Shows you follow PowerShell conventions
2. **Discoverability** - PowerShell users expect certain verbs for certain actions
3. **Consistency** - Aligns with Microsoft's own PowerShell modules
4. **Maintainability** - Makes code easier to understand for other developers

## Migration Path

For local implementation:
1. Rename the .ps1 files in your local directories
2. Update any script calls/sourcing to use new names
3. Commit and push to GitHub

## Git Commands to Commit This

```bash
# Move old files to new names
git mv Log-Message.ps1 Write-LogMessage.ps1
git mv Provision-Devices.ps1 Initialize-Devices.ps1
git mv Inject-Drivers.ps1 Add-ImageDriver.ps1
# etc...

# Commit the changes
git add .
git commit -m "Refactor: Use approved PowerShell verbs for all functions

- Log-Message → Write-LogMessage
- Provision-Devices → Initialize-Devices
- Inject-Drivers → Add-ImageDriver
- Validate-* → Test-*
- Deploy-* → Invoke-*
- Collect-* → Get-*
- Unmount → Dismount
- Setup-* → Initialize-*

This aligns with Microsoft PowerShell naming conventions for better
professionalism and discoverability."

git push origin main
```

## Reference

Microsoft PowerShell Approved Verbs:
https://learn.microsoft.com/en-us/powershell/scripting/developer/cmdlet/approved-verbs-for-powershell-commands

Key approved verbs for infrastructure automation:
- **Get** - Retrieve information
- **Test** - Verify/validate something
- **Add** - Insert/inject something
- **Remove** - Delete something
- **New** - Create something
- **Set** - Configure something
- **Write** - Output/log something
- **Initialize** - Prepare/setup something
- **Invoke** - Execute/run something
- **Mount** - Mount a filesystem/device
- **Dismount** - Unmount a filesystem/device
