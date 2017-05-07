<#

.SYNOPSIS
Find files with specifik file extentions

.DESCRIPTION

Performs the following task
    - Search through a Drive for files
    - Exports to CSV
    
            
.NOTES

        Author: Mattias Gröndahl  Date  : April 30, 2017   

        This script is to make it easier to identify intressting files during a pentest that might holöd sensitive data like passwords or PII information.

.PARAMETERS

    -path
        Enter Path to search from
        Example: ./findfiles.ps1 -path C:\

    -output
        Enter where to output the results
        Example: ./findfiles.ps1 -output C:\temp\output

    -exlude
        Enter exputions for the search
        Example ./findfiles.ps1 -exclude "*readme* *manifest*" 

.EXAMPLE 

#Run script with parameters
.\FindFiles.ps1 -path C:\temp -output C:\temp\output -exclude "*version* *readme*"

#List drives on the computer
.\FindFiles.ps1 -list drives

#Specific file type search
.\FindFiles.ps1 -filetypes "txt"

#Run the script interactive and ask for parameters
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
   [string]$list,

   [Parameter(Mandatory=$False,Position=5)]
   [string]$filetypes
)


####TODO input parameter flr filetypes
#### Exclude C:\windows from search


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


#If -type
#if ($filetypes -eq "") {
#Define Array with filetypes
$Files_array = @("txt",
                     "bak",
                     "one",
                     "pst",
                     "bat",
                     "cmd",
                     "ps1",
                     "doc",
                     "docx",
                     "vhd",
                     "sh",
                     "vmdk",
                     "p12",
                     "pfx",
                     "rdg",
                     "config",
                     "sql",
                     "msg",
                     "xml",
                     "csv",
                     "key",
                     "bkf")
#}
#else {

#Write-host "else"
#$filetypes = "bkf one config"

#$Files_array[2]
#Add new lines
#$filetypes = ($filetypes -split '\s') |? {$_}
#Takes -filetypes input and convert it to an array
#$Files_array = @($filetypes)
#Write-host "you've input filtypes $Files_array"
#    }


#If -list drives
if ($list -eq "drives") {
#Get Drives
Write-Host "Detecting Drives" -ForegroundColor DarkYellow
$drive = get-psdrive -PSProvider filesystem | select Root, @{Name="UsedGB";Expression={[math]::round($_.used/1gb,2)}}, @{Name="FreeGB";Expression={[math]::round($_.free/1gb,2)}}, @{Name="PctFree";expression={$_.free/($_.free+$_.used)*100 –as [int]}} -Wait
sleep 3
Write-host $drive.Count "drives found"
$drive
}

#Quit after list drives
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
    Write-host "No Exclution defined, using default config: $exclude" -ForegroundColor DarkYellow
}
else {
    Write-host "Excluding $Exlutions" -ForegroundColor DarkYellow
}

#If no -output
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
$outputcsv = "$output\$l" + "_files.csv"
write-host "$number | .$l files found. | $outputcsv" -foregroundcolor "green"
$content.VersionInfo |select Filename | Export-Csv -Path $output\$l"_files.csv"
}    
else {
write-host "$number | .$l files found. | $outputcsv" -foregroundcolor "magenta"
add-content $output\Overview.txt "$number | .$l files found. | $output\$l"_files".csv"
    }
}

Catch
{
    $ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    write-host "Failed to read file $FailedItem. The error message was $ErrorMessage"
    Add-content $output\Errors.log "Failed to read file $FailedItem. The error message was $ErrorMessage"
#    Break
}

}

#Error logging
Add-content $output\Errors.log "$Error `r`n"
$ErrorCount = $Error.Count

Write-host "$ErrorCount Errors found and logged in $output\Errors.log" -ForegroundColor Red

#################

sleep 5

Write-host "###################################################" -ForegroundColor DarkYellow
Write-host "#                                                 #" -ForegroundColor DarkYellow
Write-host "#                   Searching                     #" -ForegroundColor DarkYellow
Write-host "#                                                 #" -ForegroundColor DarkYellow
Write-host "###################################################" -ForegroundColor DarkYellow


#Confirm to performe search in content
$confirm = Read-host "Do you want to continue to search through the found files? Y/N"
    if ( $confirm -ne "Y" ) { exit }


#Merge from content script

#TODO path must be defnied with parameter
$confirm = Read-host "Do you want to continue to search through the found files? Y/N"
    if ( $confirm -ne "Y" ) { exit }

$listoffiles = Read-host "Enter path to the CSV file you want to perform a search on"
#$listoffiles = Get-Content -Path "$output\sh_files.csv"
#$output_file = "$path\ContentFound.txt"

#Regexp filters
$regex = '\b[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\[A-Za-z]{2,4}\b'
$url_regex = '([a-zA-Z]{3,})://([\w-]+\.)+[\w-]+([\w-./?%&=]*)*?'
$ip_regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'
#$personnr = '\b\d{6,8}\-?\d{4}\b'
$personnr = '\b\d{2}\[0-1]{1}\d{1}\[0-3]{1}\d{1}-?\d{4}\b'
$Password = ''

#Foreach loop starts
ForEach ($l2 in $listoffiles){    
#Write-Host $line    
#trim UNC path    
$input_path = $l2 -replace '["]',''

#Todo
#Fix first 2 lines in CSV

#Find Ip
$search_ip = select-string -Path $input_path -Pattern $ip_regex -AllMatches | % { $_.Matches } | % { $_.Value} 
Add-Content  $output\ip.txt $search_ip
#Find URL
$search_url = select-string -Path $input_path -Pattern $url_regex -AllMatches | % { $_.Matches } | % { $_.Value} 
Add-Content  $output\url.txt $search_url

#Find Personnr
$search_personnr = select-string -Path $input_path -Pattern $personnr -AllMatches | % { $_.Matches } | % { $_.Value} 
Add-Content  $output\personnr.txt $search_personnr
#Find Password
$search_password = select-string -Path $input_path -Pattern "password", "lösenord", "pinkod", "pass", "user"
Add-Content  $output\passwords.txt $search_password
}

###Skip C:\windows from search
