# DNX SDR Scanner & Frequenz-Manager – Prototyp Stufe 1/2

> Rein privates, unabhängiges Hobbyprojekt. Kein Projekt, Produkt oder offizielles Plugin von OpenWebRX/OpenWebRX+. Keine Verbindung, Unterstützung, Prüfung oder Empfehlung durch deren Entwickler. Nutzung auf eigene Gefahr; soweit gesetzlich zulässig keine Haftung. Vorher Backups erstellen und zuerst auf einem Testsystem prüfen.

## Enthalten

- Schalter im Receiver
- verschiebbares/maximierbares Managerfenster
- Ablösen in eigenes Browserfenster
- dauerhafte und temporäre Favoriten
- Kategorien, Icons, individuelle Farben, Formen und Priorität
- sichtbare farbige Marker auf der Frequenzskala
- Abstimmen per Schaltfläche/Doppelklick
- Favoriten-Scan
- frei kombinierbare Modusfilter mit unabhängigen Checkboxen für DMR, D-Star, TETRA, P25, NXDN, YSF, M17, FreeDV, DAB und DRM
- Schnellschalter „Alle digital“ und „Kein Filter“
- beliebige Kombinationen, beispielsweise DMR + D-Star + P25 oder DMR + TETRA + NXDN
- Bereichsscan mit Start, Ende und Schrittweite; jede Frequenz kann nacheinander in allen ausgewählten Digitalmodi geprüft werden
- S-Meter-Schwellwert, Verweil- und Haltezeit
- automatisches temporäres Speichern gefundener Signale
- JSON-/CSV-Export und JSON-Import
- vollständig markierter und entfernbarer Codeblock

## Installation auf dem aktuellen Docker-Server

Paket entpacken und im Ordner ausführen:

```bash
chmod +x install-dnx-scanner-manager.sh
sudo ./install-dnx-scanner-manager.sh install
```

Anderer Container:

```bash
CONTAINER=mein-openwebrx sudo -E ./install-dnx-scanner-manager.sh install
```

Native Installation:

```bash
MODE=native sudo -E ./install-dnx-scanner-manager.sh install
```

Danach 60–90 Sekunden warten, Browser zunächst privat öffnen und testen.

## Status und Entfernen

```bash
./install-dnx-scanner-manager.sh status
sudo ./install-dnx-scanner-manager.sh uninstall
```

Vor jeder Änderung wird `receiver/init.js` datiert gesichert. Backups bleiben beim Entfernen erhalten.

## Wichtige Hinweise

- Der Prototyp verändert standardmäßig nur die persönliche Frequenz über `UI.setFrequency()`.
- Ein automatischer Profilwechsel ist noch nicht aktiviert.
- Die Signalerkennung liest den sichtbaren S-Meter-Wert aus.
- „Squelch“ und „kombiniert“ werden im Prototyp noch über den S-Meter-/Squelch-Schwellwert angenähert; eine spätere Version kann native Squelch-Zustandsereignisse ergänzen.
- Das separate Fenster benötigt das ursprüngliche Receiverfenster als Steuerverbindung.
- Serverseitige private Listen pro Login folgen in einer späteren Stufe; aktuell stehen temporäre Sitzungsspeicherung und lokaler Browserspeicher bereit.
- CSV-Import ist noch nicht enthalten; CSV-Export und JSON-Import/Export sind vorhanden.

## Testfolge

1. OpenWebRX starten und Play drücken.
2. `Scanner / Frequenz-Manager` öffnen.
3. `Aktuelle Frequenz` anklicken.
4. Name, Kategorie, Icon und Farbe wählen.
5. Favorit speichern.
6. Favorit abstimmen.
7. Schwellwert und Verweilzeit einstellen.
8. Scan starten und mit Pause/Stopp prüfen.
9. Seite neu laden und dauerhafte Favoriten kontrollieren.
10. Temporären Favoriten anlegen und neuen Tab/Sitzung testen.

## Fehlerbehebung

Wenn Chrome/Edge hängen, zuerst in einem privaten Fenster testen. Funktioniert es dort, Website-Daten, Cache und Erweiterungen prüfen. Bei Problemen kann der Installer das Modul vollständig entfernen.

## Bereichsscan und Profilgrenzen

Der Bereichsscan arbeitet ausschließlich innerhalb des aktuell geöffneten OpenWebRX-Profils. Die erlaubte Unter- und Obergrenze wird aus `center_freq` und `bandwidth` berechnet. Start- oder Endfrequenzen außerhalb dieses Bereichs werden abgewiesen.

Das Tool schaltet bei einem normalen Bereichsscan keine Profile automatisch um. Dadurch werden andere Nutzer eines gemeinsam verwendeten Empfängers nicht durch unerwartete Profilwechsel beeinflusst.

## Optional später: profilübergreifende Scanlisten

Eine profilübergreifende Scanliste ist technisch möglich, muss aber als getrennte und besonders geschützte Funktion umgesetzt werden:

- nur für die Rolle `extended` oder `admin`
- Profile müssen ausdrücklich ausgewählt werden
- einstellbare Wartezeit nach jedem Profilwechsel
- deutlicher Hinweis, dass andere Nutzer beeinflusst werden können
- serverseitige Berechtigungsprüfung vor jedem Profilwechsel
- normale Nutzer bleiben auf das aktuell geöffnete Profil begrenzt

Diese Funktion ist in Version 1.2.0 noch nicht aktiviert.
