#Read data from file and extraxt GDRP
#Parameters$path = pwd$listoffiles = Get-Content -Path "H:\output\txt_files.csv"$output_file = 'H:\GDPR_all.txt'#$regex = '\b[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+\[A-Za-z]{2,4}\b'$url_regex = '([a-zA-Z]{3,})://([\w-]+\.)+[\w-]+([\w-./?%&=]*)*?'$ip_regex = '\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b'#$personnr = '\b\d{6,8}\-?\d{4}\b'$personnr = '\b\d{2}\[0-1]{1}\d{1}\[0-3]{1}\d{1}-?\d{4}\b'$Password = ''
################
ForEach ($line in $listoffiles){    #Write-Host $line    write-host $line    #trim UNC path    $input_path = $line -replace '["]',''    #Find Ip$search_ip = select-string -Path $input_path -Pattern $ip_regex -AllMatches | % { $_.Matches } | % { $_.Value} Add-Content  $path\Output\ip.txt $search_ip#Find URL$search_url = select-string -Path $input_path -Pattern $url_regex -AllMatches | % { $_.Matches } | % { $_.Value} Add-Content  $path\Output\url.txt $search_url
#Find Personnr$search_personnr = select-string -Path $input_path -Pattern $personnr -AllMatches | % { $_.Matches } | % { $_.Value} Add-Content  $path\Output\personnr.txt $search_personnr
#Find Password$search_password = select-string -Path $input_path -Pattern "password", "lösenord", "pinkod"Add-Content  $path\Output\passwords.txt $search_password#$search_password > H:\Output\passwords.txt       }