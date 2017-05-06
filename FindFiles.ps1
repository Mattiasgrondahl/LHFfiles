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

.\FindFiles.ps1 -path C:\temp -output C:\temp\output -exclude "*version* *readme*"
.\FindFiles.ps1 -listdrives
.\FindContent.ps1 

#>

### Parameters

[CmdletBinding()]
Param(
  [Parameter(Mandatory=$False,Position=1)]
   [string]$path,
	
   [Parameter(Mandatory=$False,Position=2)]
   [string]$output,

   [Parameter(Mandatory=$False,Position=3)]
   [string]$exclude,

   [Parameter(Mandatory=$False,Position=4)]
   [string]$list
)

#Define Help Function
Function Help{
Write-host '#############################################################################################################' -ForegroundColor DarkYellow
Write-host '#                                                                                                           #' -ForegroundColor DarkYellow
Write-host '# Example: .\FindFiles.ps1 -path C:\temp -output C:\temp\output -exclude "*version* *readme*"display help"  #' -ForegroundColor DarkYellow
Write-host '#                                                                                                           #' -ForegroundColor DarkYellow
Write-host '#############################################################################################################' -ForegroundColor DarkYellow
}

#Show Help
Help

#Define Array with filetypes
$Files_array = @("txt",
                     "bak",
                     "one",
                     "key",
                     "sh",
                     "bat",
                     "cmd",
                     "ps1",
                     "doc",
                     "docx",
                     "vhd",
                     "rdg",
                     "config",
                     "sql",
                     "msg",
                     "xml",
                     "csv",
                     "bkf")

#If -list drives
if ($list -eq "drives") {
#Get Drives
Write-Host "Detecting Drives" -ForegroundColor DarkYellow
$drive = get-psdrive -PSProvider filesystem | select Root, @{Name="UsedGB";Expression={[math]::round($_.used/1gb,2)}}, @{Name="FreeGB";Expression={[math]::round($_.free/1gb,2)}}, @{Name="PctFree";expression={$_.free/($_.free+$_.used)*100 –as [int]}} -Wait
sleep 3
Write-host $drive.Count "drives found"
$drive
}

if ( $list -eq "drives") { exit }

#If no -path
if ($path -eq "") {
#$path = Read-Host "Enter the Root to search:"
Write-host "No path defined entering interactive mode."
$path = Read-host "Enter path"
}

#Exclude the following files
if ($exclude -eq "") {
    $exclude = @("*readme*", "*EULA*", "*Version*", "*Manifest*")
    Write-host "No Exclution defined, using default yconfig: $exclude" -ForegroundColor DarkYellow
}
else {
    Write-host "Excluding $Exlutions" -ForegroundColor DarkYellow
}

##If no -output
if ($output -eq "") {
Write-host "No output path defined!"
$output = Read-host "Enter output path"
}

#Display Confguration
$conf = " -path       = $path`r`n -output     = $output`r`n -exlude     = $exclude`r`n`r`nFileTypes = $Files_array`r`nErrorLog  = $output\Error.log`r`n"
Write-host "###################################################" -ForegroundColor DarkYellow
Write-host "#                                                 #" -ForegroundColor DarkYellow
Write-host "#                   Configuration                 #" -ForegroundColor DarkYellow
Write-host "#                                                 #" -ForegroundColor DarkYellow
Write-host "###################################################" -ForegroundColor DarkYellow
Write-host $conf -ForegroundColor Magent
sleep 2

#Confirm config
$confirm = Read-host "Do you want to continue with the current configuration Y/N"
    if ( $confirm -ne "Y" ) { exit }

#Create Output folder
if (Test-Path $output) {
}
Else {
New-Item $output -type Directory
Write-host "Created folder $output"
}

#Suppress Errors (set to Continue to show errors on run)
$ErrorActionPreference = "SilentlyContinue"
$Error.count
New-Item Errors.log -type file

#ForEach loop starts here
ForEach ($l in $Files_array) {

$content = Get-ChildItem -Path $path -Filter *.$l -Recurse -Exclude $Exclutions
$count = $content.Count
$number = ($count.ToString("####")).PadLeft(6)

try {
if ($content -ne $null) { 
write-host "$number | .$line files found. | $output\$l"_files".csv" -foregroundcolor "green"
$content.VersionInfo |select Filename | Export-Csv -Path $output\$l"_files.csv"
}    
else {
write-host "$number | .$line files found. | $output\$l"_files".csv" -foregroundcolor "magenta"
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
Add-content $output\Errors.log "$Error `r`n"
$ErrorCount = $Error.Count

Write-host "$ErrorCount Errors found and logged in $output\Errors.log" -ForegroundColor Red