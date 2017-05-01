# LHFfiles
Low Hanging Fruit - locate files of intrest from shares

A collection of script to be run to identify low hanging fruits in a pentent.
Findfiles.ps1 will search through a mapped drive for files that might contain passwords or other relevant information and export them to a CSV.

Findcontent will seach through each txt file in the CSV and look for ip, url, passwords etc.

##Getting Started

1. Make sure you are on a Win7-10 machine (32 or 64bit).
2. You must be running a current version of PowerShell (v5+).
3. From an ADMINISTRATIVE PowerShell prompt, run the following command
4. iex (new-object net.webclient).downloadstring('https://github.com/Mattiasgrondahl/LHFfiles/blob/master/FindFiles.ps1')

