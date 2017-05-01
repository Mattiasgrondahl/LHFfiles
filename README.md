# LHFfiles
Low Hanging Fruit - A Collection of script to make a pentesters life easier.
This is a work in progress and some stuff might now work.

*Findfiles.ps1 will search through a mapped drive for files that might contain passwords or other relevant information and export them to a CSV for later inspection.

*FindContent.ps1 will seach through each txt file found from running FindFiles.ps1 and look for ip, url, passwords etc.

*ADAttributeDump.ps1 will search for users in the ad and export their attributes to a CSV file.

## Getting Started

1. Make sure you are on a Win7-10 machine (32 or 64bit).
2. You must be running a current version of PowerShell (v5+).
3. From an ADMINISTRATIVE PowerShell prompt, run the following command
4. iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Mattiasgrondahl/LHFfiles/master/FindFiles.ps1')
5. iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Mattiasgrondahl/LHFfiles/master/FindContent.ps1')
6. iex (new-object net.webclient).downloadstring('https://raw.githubusercontent.com/Mattiasgrondahl/LHFfiles/master/Adattributedump.ps1')

