<#

.SYNOPSIS
Find files with specifik file extentions

.DESCRIPTION

Performs the following task
    - Search through a Drive for files
    - Exports to CSV
    
            
.NOTES

        Author: Mattias Gröndahl  Date  : April 30, 2017   

Checks the following.
    -

.PARAMETERS
    -PATH
        Defined Path for the search
        C:\ D:\ E:
    -Exlude
        Defines exlutions like readme files etc
        Defnied as "*word1* *word2*" 

.EXAMPLE 

.\FindFiles.ps1 -path C:\temp -exclude "*version* *readme*"
.\FindContent.ps1 

#>

### Parameters

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False,Position=1)]
   [string]$path,
	
   [Parameter(Mandatory=$False,Position=2)]
   [string]$exclude
)

$pwd = pwd

if ($path -eq "") {
#$path = Read-Host "Enter the Root to search:"
Write-host "No Path defined, using current directory $pwd" -ForegroundColor DarkYellow
#set path to current directory
$path = $pwd
}
else {
Write-host "Using Path: $path" -ForegroundColor DarkYellow
}

#Exclude the following files
if ($exclude -eq "") {
    $exclude = @("*readme*", "*EULA*", "*Version*", "*Manifest*")
    Write-host "No Exclution defined, using default config: $exclude" -ForegroundColor DarkYellow
}
else {
    Write-host "Excluding $Exlutions" -ForegroundColor DarkYellow
}

#Create Extentions list
if (Test-Path "$pwd\Extentions.txt") {
$files = Get-Content -Path "$pwd\Extentions.txt" 
#Write-host "$msg" -foregroundcolor "green"
sleep 1
}
Else {
Write-host "File doesn't exsists creating default config"
New-Item Output -type Directory "$pwd\Output"
New-Item Output\Extentions.txt -type file
Add-content Extentions.txt "txt`r`nbak`r`ndoc`r`ndocx`r`none`r`nkey`r`nvhd`r`nsh`r`nbat`r`ncmd`r`nps1`r`nrdg`r`nconfig`r`nsql`r`nmsg"
}

#Display Confguration
$conf = "PATH = $path`r`nExlude = $exclude`r`nFileTypes = $files`r`n"
Write-host "#################" -ForegroundColor DarkYellow
Write-host "# Configuration #" -ForegroundColor DarkYellow
Write-host "#################" -ForegroundColor DarkYellow
Write-host $conf -ForegroundColor Magent
sleep 2

###

#Get Drives
$drive = get-psdrive -PSProvider filesystem | select Root, @{Name="UsedGB";Expression={[math]::round($_.used/1gb,2)}}, @{Name="FreeGB";Expression={[math]::round($_.free/1gb,2)}}, @{Name="PctFree";expression={$_.free/($_.free+$_.used)*100 –as [int]}}
$drive
sleep 1

#Suppress Errors (set to Continue to show errors on run)
$ErrorActionPreference = "SilentlyContinue"
$Error.count
New-Item Output\Errors.log -type file

#ForEach loop starts here
ForEach ($line in $extentions) {
$content = Get-ChildItem -Path $path -Filter *.$line -Recurse -Exclude $Exclutions
$count = $content.Count

try {
if ($content -ne $null) {
write-host "$count files found for .$line  Exporting to $pwd\output\$line"_files".csv" -foregroundcolor "green"
$content.VersionInfo |select Filename | Export-Csv -Path $pwd\output\$line"_files".csv
sleep 1
}    
else {
Write-host "0 files found for filetype .$line" -foregroundcolor "magenta"
sleep 1
}

}

Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    write-host "Failed to read file $FailedItem. The error message was $ErrorMessage"
    Add-content Output\Errors.log "Failed to read file $FailedItem. The error message was $ErrorMessage"
    Break
}


}

#Error logging
Add-content Output\Errors.log "$Error `r`n"
$ErrorCount = $Error.Count
Write-host "$ErrorCount Errors found and logged in Output\Errors.log"
