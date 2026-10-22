# sysinfo.ps1
# A quick health report for a Windows computer.
# Run: powershell -ExecutionPolicy Bypass -File .\sysinfo.ps1


# --- Helper: print a block of text centered in the window ---
function Show-Centered($text, $color) {
    $lines  = $text -split "`r?`n"
    $widest = ($lines | Measure-Object -Property Length -Maximum).Maximum
    $indent = " " * [int][math]::Max(0, ($Host.UI.RawUI.WindowSize.Width - $widest) / 2)

    foreach ($line in $lines) {
        Write-Host ($indent + $line) -ForegroundColor $color
    }
}


# --- Art ---
$heart = @'
  ####   ####
 ###### ######
 ######+######
  ####+++####
   ####+####
     #####
       #
'@

$title = @'
 ####  #   #   ####  ###  #   #  #####   ###
#       # #   #       #   ##  #  #      #   #
 ###     #     ###    #   # # #  ####   #   #
    #    #        #   #   #  ##  #      #   #
####     #    ####   ###  #   #  #       ###
'@


# --- Gather system info ---
$os   = Get-CimInstance Win32_OperatingSystem
$cpu  = Get-CimInstance Win32_Processor
$disk = Get-CimInstance Win32_LogicalDisk -Filter "DeviceID='C:'"

$freeRam  = [math]::Round($os.FreePhysicalMemory / 1MB, 1)
$freeDisk = [math]::Round($disk.FreeSpace / 1GB, 1)
$ip       = (ipconfig | Select-String "IPv4" | ForEach-Object { ($_.Line -split ":")[-1].Trim() }) -join ", "


# --- Build the report ---
$report = @"
Computer:   $env:COMPUTERNAME
User:       $env:USERNAME
OS:         $($os.Caption)
Last boot:  $($os.LastBootUpTime)
CPU:        $($cpu.Name)
Free RAM:   $freeRam GB
Free disk:  $freeDisk GB (C:)
IP address: $ip
"@


# --- Display ---
Write-Host ""
Show-Centered $heart  "Red"
Write-Host ""
Show-Centered $title  "Cyan"
Write-Host ""
Show-Centered $report "White"
Write-Host ""