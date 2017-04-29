<#.SYNOPSIS    ..DESCRIPTION    This script will find user in your    domain and will display their extended properties.
.EXAMPLE    C:\PS>     .NOTES    Author: Mattias Gröndahl    Date  : April 5, 2017   #>
Import-Module activedirectoryClear-Host
$Properties = @('DisplayName','SamAccountName','LastLogonDate','Enabled','AccountExpirationDate','PasswordLastSet','EmailAddress','description''LastLogonTimestamp')
#$date = 131258506728410260#function formatdate {#   [datetime]::FromFileTime($date).ToString('d MMMM yyy')#   write-host "test"#   }#formatdate
#get users and attributes$Users = Get-ADUser -Filter * -SearchBase "Ou=test,DC=test,OU=local" -Properties $Properties | sort -Property LastLogonDate -Descending
#Get enabled Aduser and the last login time$Last_users = Get-Aduser -Filter {Enabled -eq $true} -Properties Name, LastLogon | Select-Object Name, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}} | sort -Property LastLogon -Descending$i = 0$count = 0
foreach($User in $Last_users)        {            try            {#                Write-host "Getting LastLogonTime for user: " $User ´n#                Get-Aduser $user -Properties Name, LastLogon | Select-Object Name, @{n='LastLogon';e={[DateTime]::FromFileTime($_.LastLogon)}}                                  $count = $i++                            }            catch             {                write-host "error"            }
            finally            {                #Write-host "Done proccessing user"            }
}
Write-Host "Here follows a list of last logged in users:" ´n sleep 2$Last_usersWrite-host Number of users = $count
