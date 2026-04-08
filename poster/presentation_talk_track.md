# Posterpresentatie - Talk Track (4-6 min)

## 1) Opening (20-30 sec)

"Welke renderstrategie voelt sneller, en welke is echt zuiniger op je telefoon?"

Mijn onderzoek vergelijkt SSR en CSR in dezelfde Next.js-app. Niet alleen op snelheid, maar vooral op energieverbruik op een echt mobiel device.

## 2) Introductie + eerder onderzoek (40-60 sec)

- Veel vergelijkingen tussen SSR en CSR focussen op latency en UX.
- Minder studies meten expliciet client-side energie op een smartphone.
- Dat is de research gap die ik heb onderzocht.

## 3) Onderzoeksvraag (20-30 sec)

Onderzoeksvraag:
Wat verandert er in energie, timing en geheugen op het device wanneer dezelfde app via SSR of CSR wordt gerenderd?

## 4) Methode (45-60 sec)

- Zelfde storefront, zelfde interacties, alleen renderlocatie verandert.
- 60 valide runs in totaal, verdeeld over statisch, dynamisch en massief.
- Device: Samsung Galaxy A53, batterijgedreven metingen.
- Analyse met median/IQR en U-test met Bonferroni-correctie.

## 5) Resultaten met concrete voorbeelden (60-90 sec)

Kernpatroon: SSR had in alle workloads lagere totale client-side energie.

Concreet voorbeeld:

- Massief scenario: SSR 5770 mJ vs CSR 9048 mJ (ongeveer 36% lager bij SSR).

Nuance:

- In de dynamische workload liet CSR lagere vroege LCP/FCP zien.
- Toch bleef SSR over de hele run zuiniger en vaak lichter in memory.

## 6) Conclusie + aanbevelingen (45-60 sec)

Conclusie:

- Er is geen universele winnaar.
- Als batterij en totale device-cost belangrijk zijn, is SSR in deze benchmark de beste default.

Aanbevelingen:

- Kies SSR bij zwaardere workloads en als energie-efficiency centraal staat.
- Kies CSR als shell-first gedrag en client-flexibiliteit zwaarder wegen.
- Vergelijk niet alleen op gevoel van snelheid, maar combineer energie, geheugen en timing.

## 7) Vervolgonderzoek + discussie openen (30-45 sec)

Vervolg:

- Herhalen op meerdere devices en netwerken.
- Waar mogelijk hardware-based power measurement toevoegen.
- Controleren of het patroon ook buiten dit prototype standhoudt.

Discussievraag aan publiek:
"Wanneer zou jij in jouw context kiezen voor snellere eerste paint, ook als de totale device-cost hoger uitvalt?"

## Korte Q&A cheat sheet

Vraag: "Betekent dit dat SSR altijd beter is?"
Antwoord: Nee. Voor vroege perceptie kan CSR gunstig zijn. Het hangt af van je prioriteit: eerste indruk of totale device-efficiency.

Vraag: "Waarom op een echt toestel meten?"
Antwoord: Omdat energie- en geheugengedrag op echte hardware vaak afwijkt van desktop/lab-indicaties.

Vraag: "Wat is je belangrijkste praktijkadvies?"
Antwoord: Maak renderkeuzes op gecombineerde metrics: energie + geheugen + timing, niet op 1 metric.
