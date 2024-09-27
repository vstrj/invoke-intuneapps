<#
.SYNOPSIS
    This script packages applications using the IntuneWinAppUtil tool.

.DESCRIPTION
    The script takes the path to the IntuneWinAppUtil executable, the folder containing the applications, and the output folder as parameters.
    It then processes each application folder, packages the application using IntuneWinAppUtil, and outputs the results to the specified output folder.

.PARAMETER Intunepackager
    The path to the IntuneWinAppUtil executable. Default is "C:\test\IntuneWinAppUtil.exe".

.PARAMETER AppsFolder
    The path to the folder containing the applications to be packaged. Default is "C:\test\NewApps".

.PARAMETER OutputFolder
    The path to the folder where the packaged applications will be saved. Default is "C:\test\Output".

.EXAMPLE
    .\PackageApps.ps1 -Intunepackager "C:\tools\IntuneWinAppUtil.exe" -AppsFolder "C:\apps" -OutputFolder "C:\output"

.NOTES
    Author: Victor Storsjö
    Date: 27th September 2024
#>

param (
    [string]$Intunepackager = "C:\test\IntuneWinAppUtil.exe",
    [string]$AppsFolder = "C:\test\NewApps",
    [string]$OutputFolder = "C:\test\Output"
)

# Validate parameters
if (-not (Test-Path $Intunepackager)) {
    Write-Error "IntuneWinAppUtil.exe not found at $Intunepackager"
    exit
}
if (-not (Test-Path $AppsFolder)) {
    Write-Error "Apps folder not found at $AppsFolder"
    exit
}
if (-not (Test-Path $OutputFolder)) {
    Write-Error "Output folder not found at $OutputFolder"
    exit
}

# Create an empty hash table
$AppsTable = @{}

# Get subfolders for all apps
$subfolders = Get-ChildItem -Path $AppsFolder -Directory

# Loop through each subfolder
foreach ($subfolder in $subfolders) {
    # Get the file in the subfolder
    $File = Get-ChildItem -Path $subfolder.FullName -File

    # Add the subfolder and its file to the hash table
    $AppsTable[$subfolder.FullName] = $File.Name
}

# Loop through each key in AppsTable and run IntuneWinAppUtil on the files
foreach ($key in $AppsTable.Keys) {
    $Setupfolder = "{0}" -f $key
    $Setupfile = "{1}" -f $key, $AppsTable[$key]
    Write-Host "Invoking IntuneWinAppUtil on $Setupfile in $Setupfolder" -ForegroundColor Yellow
    try {
        & $Intunepackager -c $Setupfolder -s $Setupfile -o $OutputFolder -q
        Write-Host "Successfully processed $Setupfile" -ForegroundColor Green
    } catch {
        Write-Error "Failed to process $Setupfile"
    }
}

Write-Host "Done!" -ForegroundColor Cyan
