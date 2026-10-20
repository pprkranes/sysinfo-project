# sysinfo.ps1 - quick system report for troubleshooting 
# Usage: Shows a quick report about the computer

$art = @'
  ####   ####
 ###### ######
 ######+######
  ####+++####
   ####+####
     #####
       #
'@

Write-Host $art -ForegroundColor Red

$os = Get-CimInstance Win32_OperatingSystem
$cpu = Get-CimInstance Win32_Processor
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

Write-Output "=== System Info ==="
Write-Output "Computer: $env:COMPUTERNAME"
Write-Output "User: $env:USERNAME"
Write-Output "OS: $($os.Caption)"
Write-Output "Last boot: $($os.LastBootUpTime)"
Write-Output "CPU: $($cpu.NAME)"
Write-Output ""
Write-Output "Free RAM (GB): $([math]::Round($os.FreePhysicalMemory /1MB, 1))"
Write-Output "Free disk on C: (GB): $([math]::Round($disk.FreeSpace /1GB, 1))"
Write-Output ""
ipconfig | Select-String "IPv4"