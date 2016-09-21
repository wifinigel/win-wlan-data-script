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
#
# V0.01 - 19th Sept 2016 - N.Bowden (@WiFiNigel - not a real coder...)
# V0.02 - 20th Sept 2016 - (N.Bowden) Updated comments to include use of tee
#                          command in Powershell. 
#
#
# Inspired by Matt Frederick's blog post: 
# https://finesine.com/2016/09/17/using-netsh-wlan-show-interfaces-to-monitor-associationroaming/
#
# Note: to run Powershell scripts, you will most likely need to update
#       the execution policy on your machine. Open a Powershell window
#       as an adminsitrator on your machine and temporarily set the policy
#       to unrestricted with this command:
#
#		Set-ExecutionPolicy Unrestricted -scope Process
#
#       Once your powershell window is closed, this policy change is no
#       longer in effect and your machine will return to the previous
#       policy. You can check your execution policy by running the 
#       following command in Powershell:
#
#       Get-ExecutionPolicy
#
# Note2: This has only been tested on a Win 10 machine. As this is parsing
#        command output, it is very likely to break easily. It would be
#        nice to pull this data out via a more "official" route to make
#        this more robust.
#
##########################################################################


# Define loop wait time in secs
$SleepInterval = 1

# Write out CSV headers
Write-Output 'sep=,'
Write-Output "Time, Name, Description, GUID, Physical_Address, State, SSID, BSSID, Network_Type, Radio_Type, Authentication, Cipher, Connection_Mode, Channel, Receive_rate_(Mbps), Transmit_Rate_(Mbps), Signal_Level(%), Signal_Level(dBm), Profile"

# Start Loop
Do{

  # Clear all variables
  $CurrentTime = '' 
  $Name = '' 
  $Description = '' 
  $GUID = '' 
  $Physical = '' 
  $State = '' 
  $SSID = '' 
  $BSSID = '' 
  $NetworkType = '' 
  $RadioType = '' 
  $Authentication = '' 
  $Cipher = '' 
  $Connection = '' 
  $Channel = '' 
  $RecRate = '' 
  $TransRate = '' 
  $SignalLevelPercent = '' 
  $SignalLeveldBm = 0
  $Profile = ''

  #Run netsh command to get wirelss profile info
  $output = netsh.exe wlan show interfaces

  # Get time to time-stamp entry
  $CurrentTime = Get-Date

  # Name
  $Name_line = $output | Select-String -Pattern 'Name'
  $Name = ($Name_line -split ":")[-1].Trim()

  # Description
  $Description_line = $output | Select-String -Pattern 'Description'
  $Description = ($Description_line -split ":")[-1].Trim()

  # GUID
  $GUID_line = $output | Select-String -Pattern 'GUID'
  $GUID = ($GUID_line -split ":")[-1].Trim()

  # Physical Address
  $Physical_line = $output | Select-String -Pattern 'Physical'
  $Physical = ($Physical_line -split ":", 2)[-1].Trim()

  # State
  $State_line = $output | Select-String -Pattern 'State'
  $State = ($State_line -split ":")[-1].Trim()

  if ($State -eq 'connected') {

    # SSID
    $SSID_line = $output | Select-String 'SSID'| select -First 1
    $SSID = ($SSID_line -split ":")[-1].Trim()

    # BSSID
    $BSSID_line = $output | Select-String -Pattern 'BSSID'
    $BSSID = ($BSSID_line -split ":", 2)[-1].Trim()

    # NetworkType
    $NetworkType_line = $output | Select-String -Pattern 'Network type'
    $NetworkType = ($NetworkType_line -split ":")[-1].Trim()

    # RadioType
    $RadioType_line = $output | Select-String -Pattern 'Radio type'
    $RadioType = ($RadioType_line -split ":")[-1].Trim()

    # Authentication
    $Authentication_line = $output | Select-String -Pattern 'Authentication'
    $Authentication = ($Authentication_line -split ":")[-1].Trim()

    # Cipher
    $Cipher_line = $output | Select-String -Pattern 'Cipher'
    $Cipher = ($Cipher_line -split ":")[-1].Trim()

    # Connection mode
    $Connection_line = $output | Select-String -Pattern 'Connection mode'
    $Connection = ($Connection_line -split ":")[-1].Trim()

    # Channel
    $Channel_line = $output | Select-String -Pattern 'Channel'
    $Channel = ($Channel_line -split ":")[-1].Trim()

    # Receive Rate
    $RecRate_line = $output | Select-String -Pattern 'Receive rate'
    $RecRate = ($RecRate_line -split ":")[-1].Trim()

    # Transmit Rate
    $TransRate_line = $output | Select-String -Pattern 'Transmit rate'
    $TransRate = ($TransRate_line -split ":")[-1].Trim()

    # Signal (%)
    $SignalLevelPercent_line = $output | Select-String -Pattern 'Signal'
    $SignalLevelPercent = ($SignalLevelPercent_line -split ":")[-1].Trim()

    # Signal (dBm)
    $SignalLevelPercent_trimmed = $SignalLevelPercent.TrimEnd('%')
    $SignalLeveldBm = (([int]$SignalLevelPercent_trimmed)/2) - 100

    # Profile
    $Profile_line = $output | Select-String -Pattern 'Profile'
    $Profile = ($Profile_line -split ":")[-1].Trim()
  }

  Write-Output "$CurrentTime, $Name, $Description, $GUID, $Physical, $State, $SSID, $BSSID, $NetworkType, $RadioType, $Authentication, $Cipher, $Connection, $Channel, $RecRate, $TransRate, $SignalLevelPercent, $SignalLeveldBm, $Profile"

  Start-Sleep -s $SleepInterval
}
Until (0)
