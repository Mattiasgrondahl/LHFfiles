$path = pwd$searchpath = Read-Host "Skriv path att söka på ex H:\"#Get-ChildItem -Path U:\ -Filter *password* -Recurse | Out-GridView#Get-ChildItem -Path U:\ -Filter *password* -Recurse | Where-Object { $_.Attributes#$result = Get-ChildItem -Filter *s* -Recurse | Where-Object {$_.Attributes -eq "Archive, Compressed"}

$msg = "`nScript will search for the following file types $files in the path $searchpath `n"if (Test-Path "H:\Extentions.txt") {    Write-host "File exsists"    $files = Get-Content -Path "H:\Extentions.txt"        Write-host "$msg"        sleep 1    }    Else {    Write-host "File doesn't exsists creating default file"        #New-Item Output\Extentions.txt -type file    Add-content Extentions.txt "txt`r`nbak`r`ndoc`r`ndocx`r`none`r`nkey`r`nvhd`r`nsh`r`nbat`r`ncmd`r`nps1`r`nrdg"    }
$extentions = Get-Content -Path "Extentions.txt" 
if (Test-Path "$path\Output") {    sleep 1    Write-Host "folder Exsists"    }    else {    Write-Host "Creating Folder"    New-Item Output -type Directory    sleep 1    }
ForEach ($line in $extentions){    #Write-Host $line    $content = Get-ChildItem -Path $searchpath -Filter *.$line -Recurse     if ($content -ne $null)    {        write-host "Found $line files, exporting to csv"        $content.VersionInfo |select Filename | Export-Csv -Path H:\output\$line"_files".csv        sleep 1    }    else {    Write-host "Found no $line files."    sleep 1    }    }
$output_list = Get-ChildItem $path\Output$output_list
#ToDO#Filter README.txt and others
#Later#Get-Content to read in files for each file
#one file#$file = Get-ChildItem H:\servers.txt#$file.VersionInfo |select Filename
#show line number#Select-String .\servers.txt -Pattern brons |select LineNumber, Line |fl
#Search registry #ls 'HKLM:\SOFTWARE\Microsft\' -Recurse |findstr Version

