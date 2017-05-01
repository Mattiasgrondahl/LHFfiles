<#

.SYNOPSIS
Finds ActiveDirecotry Users and their attributes

.DESCRIPTION    

Performs the following task
    - Get AD users
    - List attbiutes
    - Export to CSV
    - Displays output
        
.NOTES    

Requires connection to the AD

RSAT tools need to be installed for ActiveDirectory module to be used.

        Author: Mattias Gröndahl    Date  : April 5, 2017   

Checks the following.
    -Internet Connection
    -Is RSAT installed?

.EXAMPLE    

ADAttributedump -Test
ADAttributedump -Verbose

#>

#Check for RSAT tools

$HOME
$d1 = 'WindowsTH-KB2693643-x64.msu'
$Destination =  Join-Path -Path $HOME -ChildPath "Downloads\$dl"
$URL = "https://download.microsoft.com/download/1/D/8/1D8B5022-5477-4B9A-8104-6A71FF9D98AB/" + $d1

 If (Get-HotFix -Id KB2693643 -ErrorAction SilentlyContinue) {

        Write-Verbose '---RSAT for Windows 10 is already installed'
        Write-Host '---RSAT for Windows 10 is already installed'

    } Else {

        Write-Verbose '---Downloading RSAT for Windows 10'
        Write-Host '---Downloading RSAT for Windows 10'
        $WebClient = New-Object System.Net.WebClient
        $WebClient.DownloadFile($URL, "$Destination")
        $WebClient.Dispose()
        wusa.exe $Destination /quiet /norestart /log:$home\Documents\RSAT.log

        Enable-WindowsOptionalFeature -Online -FeatureName RSATClient-Roles-AD-Powershell
    }


Import-Module activedirectory
Clear-Host

$Properties = @('DisplayName',
                    'SamAccountName',
                    'LastLogonDate',
                    'Enabled',
                    'AccountExpirationDate',
                    'PasswordLastSet',
                    'EmailAddress',
                    'description',
                    'LastLogonTimestamp')

$date = 131258506728410260
function formatdate {
[datetime]::FromFileTime($date).ToString('d MMMM yyy')
write-host "test"
}
formatdate

#get users and attributes
#$Users = Get-ADUser -Filter * -SearchBase "Ou=test,DC=test,OU=local" -Properties $Properties | sort -Property LastLogonDate -Descending
#Get enabled Aduser and the last login time
$Last_users = Get-Aduser -Filter {Enabled -eq $true} -Properties Name, LastLogon | Select-Object Name, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}} | sort -Property LastLogon -Descending $i = 0 $count = 0

foreach($User in $Last_users) {
            try {
            #Write-host "Getting LastLogonTime for user: " $User ´n
            Get-Aduser $user -Properties Name, LastLogon | Select-Object Name, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}
            $count = $i++
            }
            
            catch {
            write-host "error"
            }

            finally {        
            #Write-host "Done proccessing user"
            }
}

Write-Host "Here follows a list of last logged in users:" ´n sleep 2$Last_usersWrite-host Number of users = $count


