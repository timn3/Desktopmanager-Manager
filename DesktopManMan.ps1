# Annahme: Ultrawides sind etwa doppelt so breit, wie hoch
# Wenn ein anderer Wert gewünscht ist, kann hier geändert werden. Default: 2
$ultrawideRatio = 2

# Findet alle Bildschirme
Add-Type -AssemblyName System.Windows.Forms
$screens = [System.Windows.Forms.Screen]::AllScreens

## Prüfen, ob Desktop-Manager bereits läuft
$isProcessRunning = 0
if(Get-Process powertoys -ErrorAction Ignore) { $isProcessRunning = 1 }

## Prüfen, ob ein Ultrawide-Monitor vorhanden ist
$isUltrawide = 0
foreach($screen in $screens) {
    # Screen enthält X-Position, Y-Position, Width und Height
    $screen = $screen.WorkingArea.ToString().split(",")
    # Isolieren der Height und Width und preparation zur Berechnung
    $width = [int]$screen[2].Substring(6)
    $height = [int]$screen[3].Substring(7).Substring(0,4)
    # Berechnen des Verhältnisses Breite zu Höhe
    $ratio = [int]($width/$height).ToString().Substring(0,1)
    if($ratio -ge $ultrawideRatio) { $isUltrawide = 1 }
}

## Starten des Desktop-Managers, wenn dieser nicht läuft und ein Ultrawide angeschlossen ist
if($isUltrawide -and !$isProcessRunning) {
    $filepath = "C:\Program Files\PowerToys\PowerToys.exe"
    Start-Process $filepath
    break
}

## Stoppen des Desktop-Managers, wenn dieser läuft und kein Ultrawide angeschlossen ist
if(!$isUltrawide -and $isProcessRunning) {
    $process = Get-Process powertoys
    Stop-Process $process.Id
    break
}