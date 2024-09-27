param (
    [string]$Intunepackager = "C:\test\IntuneWinAppUtil.exe",
    [string]$AppsFolder = "C:\test\NewApps",
    [string]$OutputFolder = "C:\test\Output"

)

# Create an empty hash table
$AppsTable = @{}

#Get subfolders for all apps
$subfolders = Get-ChildItem -Path $AppsFolder -Directory

# Loop through each subfolder
foreach ($subfolder in $subfolders) {
    # Get the file in the subfolder
    $File = Get-ChildItem -Path $subfolder.FullName -File

    # Add the subfolder and its file to the hash table
    $AppsTable[$subfolder.FullName] = $File.Name
}

#Loop through each key in AppsTable and run IntuneWinAppUtil on the files
foreach ($key in $AppsTable.Keys) {
    $Setupfolder = "{0}" -f $key
    $Setupfile = "{1}" -f $key, $AppsTable[$key]
    Write-Host "Invoking Intune  WinAppUtil" -ForegroundColor Yellow
    & $Intunepackager -c $Setupfolder -s $Setupfile -o $OutputFolder -q
}

Write-Host "Done!" -ForegroundColor Cyan