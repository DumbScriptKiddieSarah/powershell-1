<#
notebookhelperSO.ps1

Hilft Notebooks nach der Windowsinstallation nach Hause zu finden

#>
#--- Variablen ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------

$neuerName = "NB02"                 # Gewuenschter Name

$loeschuser = "SIT"                 # Zu loeschender user BSP "DummerUser4"

$ssid1 = "iPAD"                    # SSID 1
$ssid2 = "Paedagogik"                    # SSID 2

$proxyserver = "10.10.10.10:8080"   # Proxy + Port BSP: "172.16.0.1:8080"

$domaintojoin = "schule.mnsplus"        # Domainname BSP: "pettingzoo.party"
    $oupfad = "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"             # Der OU-Pfad (distinguishedName) BSP: "OU=Noteboocks,OU=Raum 1408,DC=ad,DC=pettingzoo,DC=party"

$delay = "5"                       # Wartezeit nach Abschluss fuer Neustart (Script hat eigenes Delay von 5 Sekunden)


#--- Verarbeitung ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
# Phase 0 - Begruessung und Credentials

Clear-Host
Write-Host "   -- Notebook Helper -- "
Write-Host " "
Start-Sleep -Milliseconds 500

Clear-Host
Write-Host "   Hey hey hey!"
Write-Host "   Hast du dich verlaufen, kleines Notebook?"
Write-Host "   Ich helfe dir nach Hause..."
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Clear-Host
Write-Host "   Domain Credentials benoetigt!"
Write-Host " "
Write-Host " " 

$domaincredential = Get-Credential

pause

Clear-Host
Write-Host "        Neues Passwort"
Write-Host "        fuer lokaler Administrator "
Write-Host "        benoetigt!"
Write-Host " "

$adminpw = read-host "Passwort lokaler Administrator" -asSecureString                  # WLAN Key 1

Clear-Host
Write-Host "        WLAN-Key fuer SSID1"
Write-Host "        $ssid1 "
Write-Host "        benoetigt!"
Write-Host " "

$key1 = read-host "WLAN Key 1" -asSecureString                  # WLAN Key 1

Clear-Host
Write-Host "        WLAN-Key fuer SSID2"
Write-Host "        $ssid2 "
Write-Host "        benoetigt!"
Write-Host " "

$key2 = read-host "WLAN Key 2" -asSecureString                  # WLAN Key 2

#--- Phase I - Name, User, WLAN1 und Updates -------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "        Phase 1"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Remove-LocalUser -Name $loeschuser                              # Ueberfluessiger User loeschen

pause

Administrator | Set-LocalUser -Password $adminpw

pause

Clear-Host
Write-Host " Ueberfluessinger User $loeschuser entfernt!"
Write-Host " Passwort fuer lokalen Administrator gesetzt!"
Write-Host " "
Start-Sleep -Milliseconds 500
Clear-Host 

Clear-Host
Write-Host " Benenne Computer $env:computername in $neuerName um..."
Write-Host " "
Start-Sleep -Milliseconds 500
Clear-Host

Rename-Computer -NewName $neuerName

pause

    Clear-Host
    Write-Host " Erledigt... Trete WLAN1  $ssid1  bei..."
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

netsh wlan connect ssid=$ssid1 key=$key1                # WLAN join 1

pause
    
    Clear-Host    
    Write-Host " WLAN1  $ssid1  verbunden! Lade Updates..."
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

    

Install-Module -Name PSWindowsUpdate –Force             # PowerShell Update-Modul installieren
Import-Module PSWindowsUpdate                           # PowerShell Update-Modul importieren

    Download-WindowsUpdate -ForceDownload               # Updates downloaden
    Install-WindowsUpdate -ForceInstall                 # Updates installieren

    Clear-Host
    Write-Host " Updates installiert! Entferne WLAN1  $ssid1  ..."
    Write-Host " " "
    Start-Sleep -Milliseconds 500
    Clear-Host


Netsh wlan delete profile $ssid1                        # WLAN1 Profil loeschen

    Clear-Host
    Write-Host " WLAN1  $ssid1  entfernt!"
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

#--- Phase II - WLAN2, Proxy und Domainjoin -------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "        Phase 2"
Write-Host " "
Start-Sleep -Seconds 1
Clear-Host

Clear-Host
Write-Host " Setze Proxy und trete WLAN2  $ssid2  bei..."
Write-Host " "
Start-Sleep -Milliseconds 500
Clear-Host

netsh winhttp set proxy $proxyserver                    # Proxy setzen

netsh wlan connect ssid=$ssid2 key=$key2                # WLAN join 2

    Clear-Host
    Write-Host " Proxy gesetzt!"
    Write-Host " WLAN2  $ssid2  verbunden! Trete Domain bei..."
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

Add-Computer -DomainName $domaintojoin # -OUPath $oupfad -Credential $domaincredential        # Domainjoin

    Clear-Host
    Write-Host " Domain  $domaintojoin  beigetreten!"
    Write-Host " "
    Start-Sleep -Milliseconds 500
    Clear-Host

Clear-Host
Write-Host "    Alles Erledigt!"
Write-Host "    Das Notebook $env:computername ( $neuerName )"
Write-Host "    ist jetzt zuhause..."
Write-Host " "
Start-Sleep -Seconds 5
Clear-Host

Clear-Host
Write-Host "   -- Notebook Helper --"
Write-Host " "
Start-Sleep -Milliseconds 300

#------------------------------------------------------------------------------------------------------------------------------------------------------------------

Clear-Host
Write-Host "   Neustart in $delay Sekunden"
Write-Host "       Plus Fünf"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host "   Neustart in $delay Sekunden"
Write-Host "      Plus Vier"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host "   Neustart in $delay Sekunden"
Write-Host "       Plus Drei"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host "   Neustart in $delay Sekunden"
Write-Host "       Plus Zwei"
Write-Host " "
Start-Sleep -Seconds 1

Write-Host " Neustart in $delay Sekunden "
Write-Host " Plus Eins"


Start-Sleep -Seconds 1



Restart-Computer -Wait Delay $delay -Force           # Neustart