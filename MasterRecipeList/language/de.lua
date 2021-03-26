local ESOMRL = _G['ESOMRL']
local L = {}

------------------------------------------------------------------------------------------------------------------
-- German (Thanks to ESOUI.com user Baertram for the excellent translations.)
-- (Non-indented or commented lines still require human translation and may not make sense!)
------------------------------------------------------------------------------------------------------------------

-- General strings
L.ESOMRL_GAMEPADMODE			= "Master Recipe List Verfolgungssymbole und Änderungen an der Garstation werden im Gamepad-Modus nicht unterstützt!"
L.ESOMRL_SEARCHBOX				= 'Nach Rezeptnamen suchen.'
	L.ESOMRL_CLEAR				= 'Leere aktive Suchliste.'
	L.ESOMRL_ICLEAR				= 'Leere Zutaten Suchliste.'
	L.ESOMRL_TRACKING			= 'Wird beobachtet'
	L.ESOMRL_RECIPES			= 'rezepte.'
L.ESOMRL_PATTERNS				= 'schema.'
	L.ESOMRL_INGREDIENTS		= 'Zutaten.'
	L.ESOMRL_CLOSE				= 'Schließe Rezeptliste'
	L.ESOMRL_SHOWING			= 'Zeige Zutatenliste'
	L.ESOMRL_SHOWRECIPE			= 'Zeige Rezeptliste'
L.ESOMRL_SHOWFURNITURE			= 'Zeige Möbelliste'
L.ESOMRL_SHOW3DICON				= "Zeigt die Symbole neben Rezepten an, die mit der rechten Maustaste auf 3D-Vorschau klicken können."
	L.ESOMRL_LTTSHOW			= 'Aktiviere Popup Tooltips'
	L.ESOMRL_LTTHIDE			= 'Deaktiviere Popup Tooltips'
	L.ESOMRL_TTRECIPE			= 'Zeige Rezept im Tooltip an'
	L.ESOMRL_TTFOOD				= 'Zeige Nahrung im Tooltip an'
	L.ESOMRL_PSIJIC				= 'Psijik Rezepte'
	L.ESOMRL_ORSINIUM			= 'Orsinium Rezepte'
	L.ESOMRL_WITCHFEST			= 'Hexenfest Rezepte'
	L.ESOMRL_NLFEST				= 'Neujahrsfest Rezepte'
L.ESOMRL_JESTFEST				= 'Jester Festival Rezepte'
L.ESOMRL_CLOCKWORK				= 'Clockwork Stadt Rezepte'
L.ESOMRL_RANK1					= 'Rang I Rezepte'
L.ESOMRL_RANK2					= 'Rang II Rezepte'
L.ESOMRL_RANK3					= 'Rang III Rezepte'
L.ESOMRL_RANK4					= 'Rang IV Rezepte'
L.ESOMRL_RANK5					= 'Rang V Rezepte'
L.ESOMRL_RANK6					= 'Rang VI Rezepte'
L.ESOMRL_TRACKSHOWN				= 'Verfolgen Sie alle aufgeführten Rezepte.'
	L.ESOMRL_FINDWRIT			= 'Finde Schrieb Bestandteile '
	L.ESOMRL_TRACKRING			= 'Markiere alle Zutaten beobachteter Rezepte.'
	L.ESOMRL_TRACKALLING		= 'Markiere alle Zutaten.'
L.ESOMRL_TRACKOLDING			= "Nur Standardzutaten für Lebensmittel und Getränke kennzeichnen."
L.ESOMRL_TRACKNEWING			= "Nur spezielle Inhaltsstoffe und Möbelzutaten kennzeichnen."
L.ESOMRL_JUNKUING				= "Setze unmarkierte Zutaten automatisch auf die Abfall Liste.\n\nHINWEIS: Es werden nur Standardrezepte für Speisen und Getränke durchgeführt. Spezielle & Möbelzutaten werden immer ignoriert, egal ob sie verfolgt werden oder nicht."
	L.ESOMRL_DJUNKUING			= 'Beende das automatische auf die Abfall Liste setzen für unmarkierte Zutaten'
L.ESOMRL_DESTROYUING			= "Zerstöre unmarkierte Zutaten automatisch beim Looten.\n\nHINWEIS: Es werden nur Standardrezepte für Speisen und Getränke durchgeführt. Spezielle & Möbelzutaten werden immer ignoriert, egal ob sie verfolgt werden oder nicht."
	L.ESOMRL_DDESTROYUING		= 'Beende das Zerstören unmarkierte Zutaten automatisch beim Looten.'
	L.ESOMRL_LEVEL				= 'Stufe'
	L.ESOMRL_ANY				= 'Irgendein Stufe'
	L.ESOMRL_H					= '(Leben)'
	L.ESOMRL_M					= '(Magicka)'
	L.ESOMRL_S					= '(Ausdauer)'
	L.ESOMRL_HM					= '(Leben/Magicka)'
	L.ESOMRL_HS					= '(Leben/Ausdauer)'
	L.ESOMRL_MS					= '(Magicka/Ausdauer)'
	L.ESOMRL_HMS				= '(Leben/Magicka/Ausdauer)'
L.ESOMRL_UF						= "(Einzigartige Gerichte)"
L.ESOMRL_UD						= "(Einzigartige Getränke)"
L.ESOMRL_FALCH					= 'Alchemieformel'
L.ESOMRL_FBSMITH				= 'Schmiedeschema'
L.ESOMRL_FCLOTH					= 'Kleidungsmuster'
L.ESOMRL_FENCH					= 'Zauberhafte Praxis'
L.ESOMRL_FPROV					= 'Bereitstellungsdesign'
L.ESOMRL_FWOOD					= 'Holzbearbeitungsplan'
L.ESOMRL_FJEWEL					= 'Schmuck Handwerkskizzen'
	L.ESOMRL_RTRACK				= 'AUF DER REZEPT BEOBACHTUNGSLISTE'
	L.ESOMRL_ITRACK				= 'AUF VERFOLGT ZUTATENLISTE'
	L.ESOMRL_NWRITU				= 'UNBEKANNT & FÜR AKTUELLEN SCHRIEB BENÖTIGT'
	L.ESOMRL_NWRITK				= 'BEKANNT & FÜR AKTUELLEN SCHRIEB BENÖTIGT'
	L.ESOMRL_NWRIT				= 'FÜR AKTUELLEN SCHRIEB BENÖTIGT'
L.ESOMRL_NWRITNC				= "UNABSCHEIDBAR UND FÜR AKTUELLE SCHRITTE BENÖTIGT"
L.ESOMRL_NWRITCC				= "CRAFTABLE & NOTWENDIG FÜR AKTUELLES SCHREIBEN"
	L.ESOMRL_MAKE				= 'Ergibt'
	L.ESOMRL_KNOWN				= 'BEKANNT DURCH'
L.ESOMRL_UNKNOWN				= 'UNBEKANNT VON'
	L.ESOMRL_CRAFTABLE			= 'HERSTELLBAR DURCH'
L.ESOMRL_CRAFTABLEN				= 'NICHT HANDELBAR VON'
L.ESOMRL_HOUSINGCAT				= "GEHÄUSE-KATEGORIE"
	L.ESOMRL_TRACKUNKNOWN		= 'Markiere alle für diesen Charakter unbekannte Rezepte.'
	L.ESOMRL_TRACKALL			= 'Markiere alle Rezepte.'
	L.ESOMRL_JUNKURECIPE		= 'Klicke, um automatisch alle gelooteten, unmarkierten Rezepte zum Trödel zu verschieben (setze Qualitätslimit in den Einstellungen).'
	L.ESOMRL_DJUNKURECIPE		= 'Klicke, um die automatische Trödel Verschiebung für gelootete, unmarkierte Rezepte zu beenden.'
	L.ESOMRL_DESTROYURECIPE		= 'Klicke, um automatisch alle gelooteten, unmarkierten Rezepte zu zerstören (setze Qualitätslimit in den Einstellungen).'
	L.ESOMRL_DDESTROYURECIPE	= 'Klicke, um die automatische Zerstörung für gelootete, unmarkierte Rezepte zu beenden.'
	L.ESOMRL_SRCONFIGPANEL		= 'Zeige die Rezept-Beobachtung Einstellungen.'
	L.ESOMRL_HRCONFIGPANEL		= 'Verberge die Rezept-Beobachtung Einstellungen.'
	L.ESOMRL_REMOVECHAR			= 'Entferne den ausgewählten Charakter von der Beobachtungsdatenbank (log dich mit diesem ein, um ihn erneut hinzuzufügen, falls du ihn aus Versehen gelöscht hast).'
	L.ESOMRL_QUALITY1			= 'Grün'
	L.ESOMRL_QUALITY2			= 'Blau'
	L.ESOMRL_QUALITY3			= 'Lila'
	L.ESOMRL_SAVEINGTP			= 'Speichere aktuelle Zutaten Beobachtungsliste im globalen Profil.'
	L.ESOMRL_LOADINGTP			= 'Lade das globale Beobachtungs Profil für Zutaten.'
L.ESOMRL_FINDFOODRECS			= "Hier finden Sie Rezepte mit Speisen und Getränken, die ausgewählte Zutaten enthalten."
L.ESOMRL_FINDFURNRECS			= "Finden Sie Möbelrezepte mit ausgewählten Zutaten."
	L.ESOMRL_INGFOOD			= 'ZUTATEN'
	L.ESOMRL_SEARCHS			= 'Durchsuche MRL'
	L.ESOMRL_RESETNAV			= 'Navigation zurücksetzen'
	L.ESOMRL_STRACKY			= 'Beobachtete hervorheben'
	L.ESOMRL_STRACKN			= 'Beobachtete nicht hervorheben'
L.ESOMRL_NOENTRIES				= '(Keine Einträge in dieser Kategorie.)'
L.ESOMRL_ALCHEMY				= ' (Alchimie)'
L.ESOMRL_BLACKSMITHING			= ' (Schmiedekunst)'
L.ESOMRL_CLOTHING				= ' (Kleidung)'
L.ESOMRL_ENCHANTING				= ' (Zauberhaft)'
L.ESOMRL_PROVISIONING			= ' (Bereitstellung)'
L.ESOMRL_WOODWORKING			= ' (Holzverarbeitung)'
L.ESOMRL_JEWELRY				= ' (Schmuckherstellung)'
L.ESOMRL_TCDEL					= 'ESO-Vorlagenrezeptliste: Das Nachverfolgungszeichen wurde entfernt.\nÜberprüfen Sie die Addon-Einstellungen, um globale Tracking-Zeichen erneut zu aktivieren.'
L.ESOMRL_CDEL					= 'LÖSCHEN'
L.ESOMRL_EXITSTATION			= "Verlasse die Crafting Station, um eine Vorschau von der MRL anzuzeigen."
L.ESOMRL_ONLYCROWN3D			= "API - Kann nur eine Vorschau von Möbeln mit Crown-Version anzeigen."
L.ESOMRL_WRITKNOWLEGE			= "Sie wissen nicht, wie man bastelt"
L.ESOMRL_WRITING				= "Sie haben nicht genug Zutaten zum Herstellen"

-- Settings panel
L.ESOMRL_CHAROPT				= 'Charakterstatus'
L.ESOMRL_GLOBALOPT				= 'Zusatzkonfiguration'
L.ESOMRL_TCOPT					= 'Inventar Symbol Optionen'
L.ESOMRL_TIOPT					= 'Tooltipp-Optionen'
L.ESOMRL_ADOPT					= 'Auto Zerstören Optionen'
L.ESOMRL_CSOPT					= 'Kochstation Optionen'
L.ESOMRL_ADDONS					= 'FCO ItemSaver-Unterstützung'
	L.ESOMRL_ETRACKING			= 'Aktivieren Verfolgung'
L.ESOMRL_TRACKDESC				= 'Der Fortschritt des aktuellen Charakters wird im Tooltip-Abschnitt \'bekannt durch\' angezeigt (falls aktiviert).'
	L.ESOMRL_TRACKWARN			= 'WARNUNG: Wird die Benutzeroberfläche automatisch neu laden!'
	L.ESOMRL_INVENTORYI			= 'Aktiviere Symbole im Inventar'
L.ESOMRL_INVENTORYD				= 'Aktiviere das Anzeigen verschiedener Statussymbole in deinem Inventar (konfiguriere bestimmte Optionen unten).'
L.ESOMRL_INVTOOLTIP				= 'Aktivieren Sie Tooltips für das Inventarsymbol'
L.ESOMRL_INVTOOLTIPD			= 'Zeigen Sie eine QuickInfo, wenn Sie mit der Maus über die Symbole für die Inventarverfolgung fahren und erklären, was angezeigt wird.'
L.ESOMRL_INVTEXTICONS			= 'Aktivieren Sie die Symboltextüberlagerung'
L.ESOMRL_INVTEXTICONSD			= 'Zeigt eine visuelle Textmarkierung auf Inventaricons als Alternative oder zusätzlich zu Tooltips an.'
L.ESOMRL_INVTRACK				= 'Zeige Rezeptverfolgungssymbole'
L.ESOMRL_INVTRACKD				= 'Zeigt ein gelbes Inventaricon für Rezepte an, die auf die Verfolgung eingestellt sind. HINWEIS: Hat Vorrang vor dem bekannten/unbekannten Status.'
L.ESOMRL_INVWRIT				= 'Zeige Writing-Status-Icons'
L.ESOMRL_INVWRITD				= 'Zeigt ein orangefarbenes Inventar-Icon für unbekannte Rezepte an, die benötigt werden, um aktuelle Schreibanforderungen zu erstellen.'
L.ESOMRL_INVCHARU				= 'Zeige die unbekannten Rezepte des aktuellen Charakters'
L.ESOMRL_INVCHARUD				= 'Zeigt ein grünes Inventaricon für Rezepte an, die der aktuelle Charakter nicht kennt.'
L.ESOMRL_INVCHARK				= 'Zeige die bekannten Rezepte des aktuellen Charakters'
L.ESOMRL_INVCHARKD				= 'Zeigt ein graues Inventar-Symbol für Rezepte an, die der aktuelle Charakter bereits kennt.'
L.ESOMRL_TCHART					= 'Tracking-Zeichen aktivieren'
L.ESOMRL_TCHARTD				= 'Aktiviert die folgenden Optionen, um Inventaricons für die ausgewählten Zeichen global anzuzeigen.\nHINWEIS: Überschreibt die obigen zeichenspezifischen Symbole.'
L.ESOMRL_TCHAR					= 'Wählen Sie den Tracking-Charakter'
L.ESOMRL_TCHARD					= 'Nahrungsmittelrezepte, die nicht durch das ausgewählte Zeichen bekannt sind, zeigen eine grüne Kontrolle in den Vorräten.'
L.ESOMRL_FTCHAR					= 'Wählen Sie Möbel Tracking Charakter'
L.ESOMRL_FTCHARD				= 'Möbelrezepte, die nicht durch das ausgewählte Zeichen bekannt sind, zeigen eine grüne Kontrolle der Vorräte.'
L.ESOMRL_ALTIU					= 'Zeige die bekannten Rezepte des Tracking Charakters'
L.ESOMRL_ALTIUD					= 'Wenn Sie diese Option aktivieren, wird ein grauer Haken für Rezepte angezeigt, die bereits von den oben ausgewählten Zeichen bekannt sind.'
	L.ESOMRL_ICONPOSI			= 'Inventar Symbol Position'
L.ESOMRL_ICONPOSID				= 'Passen Sie die horizontale Position für Inventarverfolgungssymbole an.'
L.ESOMRL_ICONPOSS				= "Position des Anbietersymbols"
L.ESOMRL_ICONPOSSD				= "Passen Sie die horizontale Position für die NPC-Herstellerverfolgungssymbole an."
	L.ESOMRL_ICONPOSB			= 'Gildenladen Suche Symbol Position'
L.ESOMRL_ICONPOSBD				= 'Passe die horizontale Position für die Tracking-Symbole des Gildenstore-Suchergebnisses an.'
	L.ESOMRL_ICONPOSL			= 'Gildenladen Verkauf Symbol Position'
L.ESOMRL_ICONPOSLD				= 'Stelle die horizontale Position für die Gildenstore-Verkaufslisten-Tracking-Symbole ein.'
	L.ESOMRL_SHOWKNOWN			= 'Zeige \'Bekannt durch\' im Tooltip an'
	L.ESOMRL_SHOWKNOWND			= 'Ist diese Option aktiviert werden die \'Bekannt durch\' und \'Herstellbar durch\' Sektionen in allen Tooltips von Rezepten und Zutaten, für alle beobachteten Charaktere, angezeigt.'
L.ESOMRL_ALPHAN					= 'Alphabetisch \'bekannt durch\' Liste'
L.ESOMRL_ALPHAND				= 'Wenn aktiviert, wird die Tooltip-Liste \'bekannt durch\' und \'herstellbar durch\' alphabetisch sortiert. Andernfalls stimmt die Reihenfolge der Liste mit der Reihenfolge Ihrer Zeichen auf dem Anmeldebildschirm überein.'
L.ESOMRL_SKDROPDOWN				= 'Format für \'bekannt durch\' Text'
L.ESOMRL_SKDROPDOWND			= 'Wählen Sie aus, ob nur Charaktere angezeigt werden sollen, die ein Rezept kennen, nur diejenigen, die dies nicht wissen, oder beides (farblich gekennzeichnet).'
L.ESOMRL_SKCOLORK				= 'Bekannte Rezeptfarbe'
L.ESOMRL_SKCOLORKD				= 'Ändern Sie die QuickInfo-Textfarbe für aufgelistete Zeichen, die das angegebene Rezept kennen.'
L.ESOMRL_SKCOLORU				= 'Unbekannte Rezeptfarbe'
L.ESOMRL_SKCOLORUD				= 'Ändern Sie die QuickInfo-Textfarbe für aufgelistete Zeichen, die das angegebene Rezept nicht kennen.'
L.ESOMRL_SHOWFURNC				= "Möbelelementkategorie anzeigen"
L.ESOMRL_SHOWFURNCD				= "Zeigt die Wohnungskategorie zu Möbelrezepten und gefertigten Artikeln."
L.ESOMRL_SHOWINGRECS			= "Detaillierte Zutaten zu den Rezepten"
L.ESOMRL_SHOWINGRECSD			= "Wenn diese Option aktiviert ist, wird eine detaillierte Liste der erforderlichen Zutaten und wie viele davon jeweils auf den Rezeptelementen angezeigt."
L.ESOMRL_SHOWINGRECSGS			= "Keine detaillierten Rezeptzutaten bei AH"
L.ESOMRL_SHOWINGRECSGSD			= "Fügen Sie die detaillierte Zutatenliste nicht den in Gildengeschäftslisten und Suchergebnissen angezeigten QuickInfo-Tooltips hinzu."
L.ESOMRL_SHOWINGFOOD			= "Detaillierte Zutaten zu den Ergebnisartikeln"
L.ESOMRL_SHOWINGFOODD			= "Wenn diese Option aktiviert ist, wird eine ausführliche Liste der erforderlichen Zutaten und wie viele davon für die einzelnen Artikel angezeigt."
L.ESOMRL_COLORING				= "Farbe Zutaten durch Qualität"
L.ESOMRL_COLORINGD				= "Wenn diese Option aktiviert ist, werden die Einträge in der detaillierten Zutatenliste nach Artikelqualitätsstufe gefärbt."
L.ESOMRL_SHOWINGFOODGS			= "Keine detaillierten Ergebnisbestandteile bei AH"
L.ESOMRL_SHOWINGFOODGSD			= "Fügen Sie die detaillierte Zutatenliste nicht zu den in Gildengeschäftslisten und Suchergebnissen angezeigten Toolbars für umsetzbare Gegenstände hinzu."
	L.ESOMRL_RDESTROY			= 'Zerstöre Trödel Rezepte'
	L.ESOMRL_RDESTDESC			= 'Ist diese Option aktiviert und der Rezepte zum Trödel verschieben/Zerstören Pin ist an, werden unmarkierte Rezepte zerstört, und nicht zum Trödel verschoben.'
	L.ESOMRL_IDESTROY			= 'Zerstöre Trödel Zutaten'
	L.ESOMRL_IDESTDESC			= 'Ist diese Option aktiviert und der Zutaten zum Trödel verschieben/Zerstören Pin ist an, werden unmarkierte Zutaten zerstört, und nicht zum Trödel verschoben.'
L.ESOMRL_IDESTNOTE				= "HINWEIS:"
L.ESOMRL_IDESTNOTED				= "Für die beiden oben genannten Optionen müssen Sie zusätzlich die kleine Thumbtack-Schaltfläche für die entsprechende Anzeige der Master-Rezeptliste-App aktivieren. Wenn Sie Ihre verfolgten Rezepte/Zutaten ändern, werden diese Schaltflächen automatisch deaktiviert, sodass Sie sie erneut aktivieren müssen, um als Junk-Markierungen markiert oder nicht verfolgte Rezepte/Zutaten zu löschen."
	L.ESOMRL_ISTOLEN			= 'Ignoriere gestohlene Gegenstände'
	L.ESOMRL_ISTOLEND			= 'Ist diese Option aktiviert, und die weiteren Features für die automatische Markierung als Müll bzw. Löschung von unmarkierten Rezepten und Zutaten sind ebenfalls aktiviert, werden dabei gestohlene Gegenstände nicht berücksichtigt.'
	L.ESOMRL_DEBUGMODE			= 'Debugging Modus aktivieren'
	L.ESOMRL_DEBUGDESC			= 'Zeige jedes Mal Informationen im Chat an, wenn Rezeote/Zutaten zum Trödel verschobeen/zerstört werden.'
	L.ESOMRL_DQUALITY			= 'Farb-Qualität Schutz'
	L.ESOMRL_DQUALITYDESC		= 'Rezepte, deren Qualität gleich oder höher als der hier gesetzte Wert ist, werdne nicht zum Trödel verschoben oder zerstört werden. Andere Einstellungen beeinflussen diese Qualitäts-überprüfung hier NICHT!'
	L.ESOMRL_STACKSIZE			= 'Maximale Anzahl zum Zerstören'
	L.ESOMRL_STACKDESC			= 'Stapel von Zutaten mit einer höheren Anzahl, als hier festgelegt wird, werden weder als Trödel markiert, noch zerstört werden. Andere Einstellungen beeinflussen diese überprüfung hier NICHT!'
L.ESOMRL_AUTOWRITS				= "Writs automatisch erstellen"
L.ESOMRL_AUTOWRITSD				= "Stellen Sie beim Besuch einer Kochstation automatisch die Anforderungen für die Bereitstellung von Schreibvorgängen her und schließen Sie die Station, wenn Sie fertig sind."
L.ESOMRL_NOFILTERS				= 'Filter löschen beim Start'
L.ESOMRL_NOFILTERSD				= 'Automatisch wird ein überprüfen Sie die Filter \'Have Zutaten\' und \'Experte\' Wenn Sie zuerst die Kochstation öffnen.'
	L.ESOMRL_SSTATS				= 'Versorger Station Attribute Symbole'
	L.ESOMRL_SSTATSD			= 'Zeigt farbige Symbole je Nahrung & Getränk an, welche Attribute diese beeinflussen.'
	L.ESOMRL_SSTATICONS			= 'Attribut Symbol Stil'
	L.ESOMRL_SSTATICONSD		= 'Wählen Sie hier den Stil aus, welcher für die dargestellten Attribute Symbole verwendet werden soll.'
	L.ESOMRL_ICONTT1			= 'Sterne'
	L.ESOMRL_ICONTT2			= 'Kreise'
L.ESOMRL_FCOUNKNOWN				= 'Lock-Tracking-Zeichen unbekannte Rezepte'
L.ESOMRL_FCOUNKNOWND			= 'Wenn diese Option aktiviert ist, werden Rezepte, die der Charakter nicht kennt, automatisch in FCO ItemSaver gesperrt.'
L.ESOMRL_FCOUNKNOWNCO			= 'Sperren Sie unbekannte Rezepte des gegenwärtigen Charakters'
L.ESOMRL_FCOUNKNOWNCOD			= 'Wenn diese Option aktiviert ist, werden Rezepte, die das aktuelle Zeichen nicht kennt, automatisch in FCO ItemSaver gesperrt.\nHINWEIS: muss pro Zeichen aktiviert werden.'
L.ESOMRL_FCOITEM				= 'Verfolgte Elemente sperren'
L.ESOMRL_FCOITEMD				= 'Wenn diese Option aktiviert ist, werden nachverfolgte Rezepte und Zutaten automatisch in FCO ItemSaver gesperrt.'

-- Function strings
	L.ESOMRL_IDESTROYWARN		= 'Alle neu gelooteten Zutaten, welche NICHT beobachtet werden, werden DAUERHAFT zerstört!'
	L.ESOMRL_RDESTROYWARN		= 'Alle NICHT beobachteten Rezepte, deren Qualtität geringer als das hier drunter gesetzte Qualitätslimit ist, werden DAUERHAFT zerstört!'
	L.ESOMRL_ISTOLENM			= 'wurde durch gestohlene Gegenstände Filter ignoriert.'
	L.ESOMRL_IDESTROYM			= 'wurde dauerhaft gelöscht.'
	L.ESOMRL_IJUNKM				= 'wurde als Abfall markiert.'
L.ESOMRL_SKOPT1					= 'Von Charakteren bekannt'
L.ESOMRL_SKOPT2					= 'Unbekannt nach Charakteren'
L.ESOMRL_SKOPT3					= 'Zeig beides'
L.ESOMRL_SKOPT4					= 'Die Umschalttaste schaltet um'
L.ESOMRL_NONAMEU				= 'Von allen verfolgten Charakteren unbekannt.'
L.ESOMRL_NONAMEK				= 'Von allen verfolgten Charakteren bekannt.'
L.ESOMRL_NONAMEN				= 'Keine Zeichen zum Nachverfolgen festgelegt.'
L.ESOMRL_ITT_TK					= "Bekannt durch Tracking-Charakter"
L.ESOMRL_ITT_CK					= "Bekannt durch den aktuellen Charakter"
L.ESOMRL_ITT_TU					= "Unbekannt durch Tracking-Charakter"
L.ESOMRL_ITT_CU					= "Unbekannt nach aktuellem Charakter"
L.ESOMRL_ITTMRLT				= 'Von MRL verfolgt'
L.ESOMRL_ITTWRITR				= 'Erstellt Schreibanforderung'
L.ESOMRL_ITTWRITI				= 'Erforderlich durch schriftliche'
L.ESOMRL_ITTWRITC				= 'Rezeptbestandteil schreiben'
L.ESOMRL_Status1				= "Ausgewählten Charakter Status:"
L.ESOMRL_Status2				= "Weiß "
L.ESOMRL_Status3				= " Rezepte der Bereitstellung."
L.ESOMRL_Status4				= " Möbelrezepte."
L.ESOMRL_Status5				= "   Gesamt: "
L.ESOMRL_Status6				= " Unbekannte: "
L.ESOMRL_UPDATE1				= "[MRL]: Datenbank der Hauptrezeptliste aktualisiert."
L.ESOMRL_UPDATE2				= "[MRL]: Bitte /reloadui zu vervollständigen."

-- Info tooltip
	L.ESOMRL_IKNOWN				= ' = Bekanntes Rezept.'
	L.ESOMRL_IKNOWNT			= ' = Bekanntes Rezept, wird beobachtet.'
	L.ESOMRL_IUNKNOWN			= ' = Unbekanntes Rezept.'
	L.ESOMRL_IUNKNOWNT			= ' = Unbekanntes Rezept, wird beobachtet.'
	L.ESOMRL_IWRIT				= ' = Unbekannt, für Schrieb benötigt.'
	L.ESOMRL_IWTRACK			= ' = Unbekannt, für Schrieb benötigt, wird beobachtet.'
	L.ESOMRL_SHIFTCLICK			= 'Shift-Klicke Gegenstände, um sie im Chat zu verlinken.'
	L.ESOMRL_INGGOLD			= 'Beobachtete Zutaten sind Gold eingefärbt.'

-- Food categories
	L.ESOMRL_FOOD				= 'Essen'
	L.ESOMRL_TFOOD				= 'Essen Rezepte'

-- Drink categories
	L.ESOMRL_DRINK				= 'Getränk'
	L.ESOMRL_TDRINK				= 'Getränk Rezepte'

-- String Matching (these must match the game client and should not be changed unless testing a custom localization!)
	L.ESOMRL_Recipe				= "Rezept für "
	L.ESOMRL_ANY2				= "Irgendein Stufe Rezept für "
	L.ESOMRL_WRITQUEST			= 'Versorgerschrieb'
	L.ESOMRL_WRITFINISH			= 'Beliefert'


------------------------------------------------------------------------------------------------------------------

if (GetCVar('language.2') == 'de') then -- overwrite GetLanguage for new language
	for k,v in pairs(ESOMRL:GetLanguage()) do
		if (not L[k]) then -- no translation for this string, use default
			L[k] = v
		end
	end

	function ESOMRL:GetLanguage() -- set new language return
		return L
	end
end
