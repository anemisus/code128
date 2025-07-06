Readme zu code128.sh
====================

[![code128.sh Preview](https://raw.githubusercontent.com/anemisus/code128/main/preview.png)](#readme)

**code128.sh ist ein Skript für Linux**, mit dem sich Barcodes im Format
[Code128](https://de.wikipedia.org/wiki/Code128) direkt im Terminal darstellen
lassen. Es nutzt dafür die [Unicode-Blockelemente](https://de.wikipedia.org/wiki/Unicodeblock_Blockelemente),
aus denen die Darstellung zusammengepuzzelt wird.

# Installation und Nutzung

1. Lade dir die Datei [code128.sh](https://raw.githubusercontent.com/anemisus/code128/refs/heads/main/code128.sh) aus diesem Repository herunter.

2. Installiere die Datei z. B. nach `/usr/local/bin/`:

        sudo install code128.sh /usr/local/bin/code128

3. Führe den Befehl `code128` im Terminal aus, *eventuell neue Sitzung erforderlich*.

# FAQ

## F: Was sind Code-Sets?

A: Der Code128-Standard codiert Daten auf drei verschiedene Arten, die je nach
Anwendungszweck unterschiedlich gut geeignet sein können.

---

💡 **Parameter `-c [b|c|x]` legt fest, welches Code-Set verwendet wird.**

---

📚 **Code-Set B** lässt so ziemlich alle lateinischen Buchstaben, Ziffern,
Interpunktion, Sonderzeichen und Leerzeichen zu. Es ist daher in den meisten
Fällen die richtige Wahl und wird deshalb auch als Standardeinstellung
verwendet, wenn man keinen Parameter angibt.

🧮 **Code-Set C** beschränkt sich auf Ziffernpaare von `00` bis `99` und codiert
diese effizienter als Code-Set B. Es sollte dann verwendet werden, wenn man nur
Zahlen codieren möchte, etwa für eine Artikelnummer oder einen Zeitstempel.

⚙️ **Code-Set X** (als Ersatz für Code-Set A) erfordert eine direkte Eingabe von
kommaseparierten Index-Werten. Mögliche Werte können mit dem Befehl `code128 -m`
tabellarisch angezeigt werden. Es eignet sich, um mehrere Code-Sets zu mischen
und Spezialfunktionen zu codieren, etwa zur Konfiguration eines Handscanners.
Dies ist etwas für Experten.

## F: Wie steuere ich das Erscheinungsbild der Ausgabe?

A: Dafür stehen verschiedene optionale Parameter zur Verfügung:

- Parameter `-d` gibt zusätzlich eine menschenlesbare Beschreibung aus.  
  *nur für Code-Sets B und C*

- Parameter `-i` invertiert die Farben der Ausgabe.  
  *gut für helle Terminals*

- Parameter `-p [num]` fügt oberhalb und unterhalb des Barcodes Ruhezonen hinzu.  
  *`[num]` = gewünschte Anzahl der Zeilen (standardmäßig 0)*

- Parameter `-s [num]` legt die Höhe des Barcodes fest.  
  *`[num]` = gewünschte Anzahl der Zeilen (standardmäßig 0)*

## F: Warum sieht die Ausgabe kaputt aus? 🥴

A: Damit der Barcode richtig dargestellt wird, muss das Terminal-Fenster eine
horizontale Mindestbreite haben, die stark vom Inhalt des Barcodes abhängt (mehr
Inhalt führt zu längeren Barcodes). Oft reicht es, wenn du das Fenster etwas
breiter ziehst.

Es kann auch sein, dass dein Terminal-Emulator keine Monospace-Schriftart
benutzt oder - meist aufgrund von unpassendem Text-Zoom - störende Räume
zwischen den Zeichen darstellt. Wechsle also ggf. die Schriftart und spiele mit
der Schriftgröße herum, bis es passt.

## F: Wie erhalte ich weitere Hilfe?

- Parameter `-h` zeigt eine gekürzte Version dieser README in englischer Sprache.
- Parameter `-m` gibt eine Übersicht der Mappings aller Code-Sets aus.
- Parameter `-v` ruft die Version dieses Skripts ab.

## F: Warum funktioniert es nicht? 💔

A: Schwer zu sagen. Vielleicht hast du etwas falsch gemacht oder Skript
beinhaltet einen Fehler? Du kannst versuchen, das Skript mit dem `--debug`
Parameter auszuführen, um zu schauen, an welcher Stelle etwas fehlschlägt.

Das Skript wurde zuletzt mit GNU bash Version 5.2.15 getestet.

## F: Fingerprint des Signaturschlüssels?

A: Er lautet `804ABD4A66A66E5242131FAB14AAF2972A56D0F8`.

Du kannst den Schlüssel z. B. auf [keys.openpgp.org](https://keys.openpgp.org/) suchen und herunterladen.
