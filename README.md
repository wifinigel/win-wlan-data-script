# win-wlan-data-script
A script to parse the output of the 'netsh wlan show interfaces' cmd &amp; turn it into a more interesting format 

##########################################################################
#
# Windows WLAN Data Powershell script
#
# Run this script from a Windows powershell (as admin) and get the output
# from the "netsh wlan show interfaces" command ouput in CSV form. Pipe the
# output in to a filename to save as a file:
#
# wlan_data_v0.02.ps1 >> c:\temp\wlan_data.csv
#
# ALternatively, to monitor the output at the same time as writing to the 
# CS file, us this command in the Powershell:
#
# wlan_data.ps1 | Tee-Object -file test.csv


 Inspired by Matt Frederick's blog post: 
 https://finesine.com/2016/09/17/using-netsh-wlan-show-interfaces-to-monitor-associationroaming/

 Note: to run Powershell scripts, you will most likely need to update
       the execution policy on your machine. Open a Powershell window
       as an adminsitrator on your machine and temporarily set the policy
       to unrestricted with this command:

		Set-ExecutionPolicy Unrestricted -scope Process

       Once your powershell window is closed, this policy change is no
       longer in effect and your machine will return to the previous
       policy. You can check your execution policy by running the 
       following command in Powershell:

       Get-ExecutionPolicy

 Note2: This has only been tested on a Win 10 machine. As this is parsing
        command output, it is very likely to break easily. It would be
        nice to pull this data out via a more "official" route to make
        this more robust.

