﻿--[[

LibQuestData
by Sharlikran
https://sharlikran.github.io/

^(\d{1,4}), "(.*)"
    \[\1] = "\2",

(.*) = "(.*)" = "(.*), ",
"\2", = \{\3\,},

^"(.*)", = \{(.*)\},
    \["\1"] = \{\2 },
--]]
local lib = _G["LibQuestData"]

lib.quest_givers["de"] = {
	   [601] = "Leon Milielle",
	   [901] = "Kammerherr Weller",
	   [906] = "Herzog Sebastien",
	  [1872] = "Baron Alard Dorell",
	  [1953] = "Sir Edmund",
	  [2048] = "Söldner",
	  [2089] = "General Godrun",
	  [2321] = "Konstabler Agazu",
	  [2442] = "Gräfin Ilise Manteau",
	  [2697] = "Michel Gette",
	  [3134] = "William Nurin",
	  [4904] = "Lothson Kaltauge",
	  [4982] = "Valdam Andoren",
	  [5057] = "erster Maat Elvira Derre^FMc",
	  [5126] = "Dro-Dara",
	  [5127] = "Knarstygg",
	  [5269] = "Michel Helomaine",
	  [5298] = "Hauptmann Dugakh",
	  [5424] = "Mathias Raiment",
	  [5444] = "Janne Marolles",
	  [5697] = "Blaise Pamarc",
	  [5752] = "Schwester Tabakah",
	  [5830] = "Hosni at-Tura",
	  [5837] = "Arcady Charnis",
	  [5880] = "Geron Drothan",
	  [5894] = "Adiel Charnis",
	  [5897] = "Serge Arcole",
	  [6016] = "Meister Altien",
	  [6017] = "Abt Durak",
	  [6062] = "Bruder Alphonse",
	  [6063] = "Schwester Safia",
	  [6188] = "Wachthauptmann Rama",
	  [6216] = "Pierre Lanier",
	  [6225] = "Wachhauptmann Kurt",
	  [6235] = "Bruder Perry",
	  [6332] = "Wachthauptmann Ernard",
	  [6359] = "Falice Menoit",
	  [6396] = "Großkönig Emeric",
	  [6505] = "Bruder Gerard",
	  [6624] = "Tyree Marence",
	  [6849] = "Ingride Vanne",
	  [6898] = "Sir Graham",
	  [8204] = "Wyrdin Shannia",
	  [8250] = "Königin Arzhela",
	  [8959] = "Ufa die Rote Natter",
	  [9320] = "Master Muzgu",
	  [9479] = "Feldwebel Stegine",
	 [10098] = "König Fahara'jad",
	 [10099] = "Gurlak",
	 [10107] = "Prinz Azah",
	 [10165] = "Gabrielle Benele",
	 [10193] = "Thronhüter Farvad",
	 [10355] = "Ramati at-Gar",
	 [10533] = "Kasal",
	 [10575] = "Hauptmann Rawan",
	 [10714] = "Rajesh",
	 [10758] = "Goldküsten-Späher",
	 [10884] = "Talia at-Marimah",
	 [11019] = "Leichnam^fm",
	 [11315] = "Qadim",
	 [11580] = "Bruder Zacharie",
	 [11639] = "Hubert",
	 [11776] = "Konstabler Ketrique",
	 [11987] = "M'jaddha",
	 [11994] = "Phinis Vanne",
	 [12012] = "Fürstin Sirali at-Tura",
	 [12025] = "Kapitän Albert Marck",
	 [13001] = "Priesterin Pietine",
	 [13020] = "Dame Dabienne",
	 [13123] = "Merthyval Lort",
	 [13134] = "Margot Oscent",
	 [13156] = "General Thoda",
	 [13318] = "Herzogin Lakana",
	 [13490] = "Unheilsbrut",
	 [13965] = "Großkriegsfürstin Sorcalin",
	 [13982] = "Ansei Halelah",
	 [13983] = "Abatis",
	 [13988] = "Hauptmann Aresin",
	 [14080] = "Wächterin des Wassers^fd",
	 [14087] = "Dolchsturz-Patrouille^mf",
	 [14090] = "Hauptmann Farlivere",
	 [14096] = "Wyrdin Helene",
	 [14098] = "Bernard Redain",
	 [14110] = "Schweinehirte Wickton",
	 [14118] = "Fürst Arcady Noellaume",
	 [14180] = "Wyrdin Jehanne",
	 [14194] = "Bettler Matthew",
	 [14261] = "Königin Maraya",
	 [14299] = "Gloria Fausta",
	 [14308] = "Guy LeBlanc",
	 [14328] = "Bumnog",
	 [14341] = "Fürst Alain Diel",
	 [14358] = "Anruferin Grahla",
	 [14382] = "Hohepriester Zuladr",
	 [14464] = "Alexia Dencent",
	 [14532] = "Erwan Castille",
	 [14580] = "Leonce Diel",
	 [14619] = "Alana Relin",
	 [14648] = "Späher Hanil",
	 [14660] = "Sir Marley Oris",
	 [14678] = "König Donel Deleyn",
	 [14708] = "Wyrdin Ileana",
	 [14763] = "General Gautier",
	 [14810] = "General Mandin",
	 [14811] = "Fürstin Eloise Noellaume",
	 [14869] = "Kommandant Marone Ales",
	 [14970] = "Darien Gautier",
	 [14992] = "Tamien Sellan",
	 [15015] = "Wyrdin Gwen",
	 [15034] = "Ildani",
	 [15047] = "Harald Winntal",
	 [15079] = "Merien Sellan",
	 [15340] = "Stibbons",
	 [15342] = "Fürstin Clarisse Laurent",
	 [15350] = "Lort der Totengräber",
	 [15496] = "Jowan Hinault",
	 [15531] = "Letta",
	 [15595] = "Sir Malik Nasir",
	 [15620] = "Richard Dusant",
	 [15651] = "Adifa Dünengänger",
	 [15680] = "Shiri",
	 [15705] = "Wyrdin Demara",
	 [15843] = "Sir Lanis Shaldon",
	 [15876] = "Feldwebel Eubella Bruhl",
	 [15877] = "Kahaba",
	 [15984] = "Odei Philippe",
	 [16111] = "Hayazzin",
	 [16147] = "Marent Ergend",
	 [16170] = "königliche Leibwache",
	 [16239] = "Anjan",
	 [16430] = "Hadoon",
	 [16507] = "Renoit Leonciele",
	 [16574] = "Onwyn",
	 [16579] = "Samsi af-Bazra",
	 [16601] = "Musi",
	 [16686] = "Rekrut Thomas",
	 [16696] = "Athel Baelkind",
	 [16730] = "Rahannal",
	 [16828] = "Unteroffizier Aldouin",
	 [16984] = "Jarrod",
	 [17131] = "Heroldin Kixathi",
	 [17185] = "Mazrahil der Schlaue Skarabäus",
	 [17262] = "Basile Fenandre",
	 [17269] = "Nemarc",
	 [17393] = "Garmeg der Eisenfinder",
	 [17394] = "Wyrdin Freyda",
	 [17439] = "Wyrdin Rashan",
	 [17482] = "Ayma",
	 [17508] = "Sir Edgard",
	 [17658] = "merkwürdige Krähe",
	 [17832] = "Gurhul gra-Khazgur",
	 [17887] = "Yarah",
	 [18095] = "Graf Verandis Rabenwacht",
	 [18238] = "Hauptmann Hjolm",
	 [18239] = "Hauptmann Llaari",
	 [18241] = "Pakt-Soldatin",
	 [18317] = "Hauptmann Noris",
	 [18365] = "Holgunn",
	 [18366] = "Tanval Indoril",
	 [18372] = "Feldwebel Rhorlak",
	 [18373] = "Furon Rii",
	 [18374] = "Reesa",
	 [18377] = "Aeridi",
	 [18378] = "Guraf Hroason",
	 [18379] = "Rorygg",
	 [18380] = "Weiche-Schuppe",
	 [18405] = "Vartis Dareel",
	 [18427] = "Ix-Utha",
	 [18436] = "Feldwebel Eila",
	 [18506] = "Schreitet-in-Asche",
	 [18549] = "Naryu Virian",
	 [18551] = "Varon Davel",
	 [18589] = "Svanhildr",
	 [18640] = "Priesterin Brela",
	 [18642] = "Drelden Orn",
	 [18647] = "Fendell",
	 [18661] = "Garyn Indoril",
	 [18691] = "Heiler Senar",
	 [18706] = "Idrasa",
	 [18727] = "Feldwebel Ren",
	 [18759] = "Norgred Harthelm",
	 [18764] = "Madras Tedas",
	 [18813] = "Krallt-sich-Fisch",
	 [18814] = "Vara-Zeen",
	 [18819] = "Leel-Vata",
	 [18820] = "Zauberer Vunal",
	 [18824] = "Cloya",
	 [18826] = "Onuja",
	 [18848] = "Ratsherr Ralden",
	 [18849] = "Mavos Siloreth",
	 [18870] = "Zauberin Nilae",
	 [18942] = "Bala",
	 [19003] = "Hrogar",
	 [19004] = "Uggonn",
	 [19030] = "Fafnyr",
	 [19057] = "Sar-Keer",
	 [19099] = "Weitseherin Bodani",
	 [19148] = "Jin-Ei",
	 [19169] = "Feldwebel Gjorring",
	 [19187] = "Hennus",
	 [19216] = "Nilthis",
	 [19244] = "Beron Telvanni",
	 [19257] = "Zasha-Ja",
	 [19268] = "Feldsii Maren",
	 [19272] = "Ruvali Manothrel",
	 [19279] = "Merarii Telvanni",
	 [19321] = "Azeenus",
	 [19385] = "Feldwebel Rila Lenith",
	 [19403] = "Edrasa Drelas",
	 [19515] = "Hraelgar Steinschlag",
	 [19684] = "Ragna Sturmhang",
	 [19705] = "Jünger Sildras",
	 [19762] = "Hauptmann Diiril",
	 [19764] = "Senil Fenrila",
	 [19768] = "Ein-Auge",
	 [19790] = "Kotholl",
	 [19796] = "Feldwebel Hadril",
	 [19809] = "Neposh",
	 [19826] = "Fervyn",
	 [19843] = "Karawanenmeister Girano",
	 [19901] = "Häuptling Suhlak",
	 [19929] = "Späher Kanat",
	 [19933] = "Feldwebel Larthas",
	 [19939] = "Großmeister Omin Dres",
	 [19941] = "Denu Faren",
	 [19947] = "Vizekanoniker Hrondar",
	 [19958] = "Vizekanonikerin Heita-Meen",
	 [19960] = "Sen Dres",
	 [19963] = "Ral Savani",
	 [20052] = "S'jash",
	 [20054] = "Bimee-Kas",
	 [20083] = "Zweifelt-am-Mond",
	 [20126] = "Saryvn",
	 [20144] = "Späher Galsar",
	 [20146] = "Qa'tesh",
	 [20182] = "zerschlagene Dwemersphäre",
	 [20183] = "Vizekanonikerin Servyna",
	 [20217] = "Wareem",
	 [20261] = "Kiameed",
	 [20297] = "Daeril",
	 [20342] = "Churasu",
	 [20349] = "Drillk",
	 [20369] = "Bedyni die Artefaktorin",
	 [20373] = "Kurat Brethis",
	 [20374] = "Heilerin Ravel",
	 [20436] = "Jilux",
	 [20455] = "Rabeen-Ei",
	 [20475] = "Xijai-Teel",
	 [20476] = "Parash",
	 [20494] = "Padeehei",
	 [20497] = "Gareth",
	 [20499] = "Desha",
	 [20567] = "Feldwebel Jagyr",
	 [20661] = "Ordinator Muron",
	 [20693] = "Almalexia",
	 [20695] = "Ältester Sieben-Bäuche",
	 [20702] = "Feldwebel Aamrila",
	 [20749] = "Ordinatorin",
	 [21096] = "Kampfmagier Gaston",
	 [21114] = "Sia",
	 [21163] = "Lacht-über-alles",
	 [21175] = "Chitakus",
	 [21176] = "Lodyna Arethi",
	 [21237] = "Schläft-mit-offenen-Augen",
	 [21261] = "Leises-Moos",
	 [21265] = "Bleiches-Herz",
	 [21401] = "Relnus Andalen",
	 [21402] = "Ven Andalen",
	 [21424] = "Akolyth Krem",
	 [21425] = "Orona",
	 [21436] = "Rigurt der Ungestüme",
	 [21452] = "Aspera die Vergessene",
	 [21483] = "Neeta-Li",
	 [21485] = "Kara",
	 [21540] = "Bruder Samel",
	 [21676] = "Elynisi Arthalen",
	 [21683] = "Verzweifelter^md",
	 [21758] = "Lange-Krallen",
	 [21762] = "Schneller-Finder",
	 [21851] = "Lyranth",
	 [21966] = "kaiserlicher Forscher",
	 [21980] = "Gerent Saervild Stahlwind",
	 [21987] = "Gerent Hernik",
	 [21993] = "Bezeer",
	 [21994] = "Jurni",
	 [22014] = "Damrina",
	 [22039] = "Baumhirtin Raleetal",
	 [22345] = "Gildenmeisterin Sieht-alle-Farben",
	 [22368] = "Aelif",
	 [22380] = "Naril Heleran",
	 [22388] = "Streift-in-Schatten",
	 [22411] = "Napetui",
	 [22412] = "Sejaijilax",
	 [22425] = "Kireth Vanos",
	 [22426] = "Raynor Vanos",
	 [22461] = "Shaali Kulun",
	 [22486] = "Duryn Beleran",
	 [22487] = "Erranza",
	 [22562] = "Priesterin Dilyne",
	 [22775] = "Ordinatorin Gorili",
	 [22792] = "Baumhirtin",
	 [22864] = "Schaut-unter-Steine",
	 [22909] = "Ganthis",
	 [23029] = "Nosaleeth",
	 [23111] = "Feyne Vildan",
	 [23205] = "Erzmagier Valeyn",
	 [23215] = "Telbaril Oran",
	 [23219] = "Knappe der Saatkrähen^md",
	 [23267] = "Aamela Rethandus",
	 [23353] = "Gerent Nuleem-Malem",
	 [23400] = "Tah-Tehat",
	 [23455] = "Priesterin Madrana",
	 [23459] = "Valaste",
	 [23460] = "Erzmagier Shalidor",
	 [23503] = "Nojaxia",
	 [23511] = "Vigrod Gespenstertod",
	 [23512] = "Engling",
	 [23528] = "Hauptmann Viveka",
	 [23534] = "Dajaheel",
	 [23535] = "Vorarbeiter Gandis",
	 [23545] = "Jaknir",
	 [23584] = "Wissensbewahrer Bragur",
	 [23601] = "Jorunn der Skaldenkönig",
	 [23604] = "Königin Ayrenn",
	 [23605] = "Hauptmann Odreth",
	 [23606] = "Razum-dar",
	 [23609] = "König Kurog",
	 [23731] = "Späher Claurth",
	 [23747] = "Zenturio Gjakil",
	 [23748] = "Tovisa",
	 [23770] = "Hodmar",
	 [23781] = "Feldwebel Nen^Mf",
	 [23829] = "Melril",
	 [23845] = "Leutnant Belron",
	 [23847] = "Damar",
	 [23849] = "Paldeen",
	 [23859] = "Akolythin Gami",
	 [24034] = "Vanus Galerion",
	 [24154] = "Maahi",
	 [24188] = "Treva",
	 [24224] = "Netapatuu",
	 [24261] = "Hoknir",
	 [24276] = "Bura-Natoo",
	 [24277] = "Hauptmann Rana",
	 [24316] = "Darj der Jäger",
	 [24317] = "Rolunda",
	 [24318] = "Feldwebel Seyne",
	 [24322] = "Molla",
	 [24333] = "Vila Theran",
	 [24369] = "Aera Erdwender",
	 [24387] = "Halmaera",
	 [24761] = "Prophet^md",
	 [24895] = "Hamill",
	 [24903] = "Nolu-Azza",
	 [24905] = "Vudeelai",
	 [24959] = "Kralald",
	 [24966] = "Thulvald Axtkopf",
	 [24968] = "Wenaxi",
	 [24987] = "Hauptmann Alhana",
	 [25014] = "Fresgil",
	 [25043] = "Yraldar Schneegipfel",
	 [25052] = "Esqoo",
	 [25053] = "Fens Schneegipfel",
	 [25080] = "Elf-Sprünge",
	 [25108] = "Nelerien",
	 [25154] = "Valeric",
	 [25163] = "Hanmaer Pelzflicker",
	 [25210] = "Zenturio Mobareed",
	 [25303] = "Eiserne-Klauen",
	 [25374] = "Praxin Douare",
	 [25413] = "Jorygg Öddämmern",
	 [25544] = "Leutnant Koruni",
	 [25546] = "Hauptmann Hamar",
	 [25600] = "Murilam Dalen",
	 [25604] = "Thane Mera Sturmmantel",
	 [25618] = "Jurana",
	 [25622] = "Bishalus",
	 [25663] = "Königin Nurnhilde",
	 [25688] = "Prinz Irnskar",
	 [25720] = "General Yeveth Noramil",
	 [25779] = "Ula-Reen",
	 [25781] = "Talmo",
	 [25789] = "Wächter Sud-Hareem",
	 [25800] = "Sena Aralor",
	 [25882] = "Kurator Nicholas",
	 [25907] = "Hilan",
	 [25939] = "Thane Harvald",
	 [25940] = "Thane Oda Wolfsschwester",
	 [26087] = "Hlotild die Füchsin",
	 [26090] = "Akolythin Madrana",
	 [26098] = "Aspera Riesenfreund",
	 [26099] = "grüne Dame^fdc",
	 [26188] = "Finvir",
	 [26217] = "Cadwell",
	 [26225] = "Weber Gwilon",
	 [26226] = "Weberin Endrith",
	 [26314] = "Frirvid Kaltstein",
	 [26317] = "Silvenar^md",
	 [26324] = "Berj Steinherz",
	 [26509] = "Mathragor",
	 [26601] = "Lothgar Ruhighand",
	 [26655] = "Hüter Cirion",
	 [26767] = "Elandora",
	 [26768] = "Salgaer",
	 [26810] = "Gakurek",
	 [26885] = "Sturmgraue-Augen",
	 [26926] = "Selgaard Holzstemmer",
	 [26955] = "königliche Leibwache",
	 [26956] = "königliche Leibwache^mf",
	 [26964] = "Hohepriester Esling",
	 [26969] = "Mariel die Eisenhand",
	 [27022] = "Ollslid",
	 [27023] = "Fjorolfa",
	 [27063] = "Jomund Auenschnee",
	 [27295] = "Helgith",
	 [27323] = "Stürmerin Aldewe",
	 [27324] = "erster Maat Valion^Mc",
	 [27326] = "Seemann Ambaran",
	 [27340] = "Nedrek",
	 [27352] = "Galithor",
	 [27354] = "Nila Belavel",
	 [27473] = "Valdur",
	 [27560] = "Sela",
	 [27605] = "Weise Tirora",
	 [27687] = "Hokurek",
	 [27743] = "Tervur Sadri",
	 [27744] = "Hloenor Frosteule",
	 [27848] = "Aering",
	 [27926] = "Späher Fenrir",
	 [27966] = "Farandor",
	 [27971] = "Shandi",
	 [27998] = "Hallfrida",
	 [28005] = "Feldwebel Sjarakki",
	 [28082] = "Kerig",
	 [28127] = "Enthis Hlan",
	 [28198] = "Hengehüterin Lara",
	 [28206] = "Rudrasa",
	 [28261] = "Atirr",
	 [28281] = "Hauptmann Vari Kriegshammer",
	 [28283] = "Snorrvild",
	 [28331] = "Finoriells Seele^Fg",
	 [28480] = "Singt-beim-Trinken",
	 [28490] = "Eraral-dro",
	 [28493] = "Verführerin Trilvath",
	 [28505] = "Bera Moorschmied",
	 [28539] = "Laen die Torschreiterin",
	 [28611] = "Seemann Henaril",
	 [28612] = "Seemann Sorangarion",
	 [28659] = "Alphrost",
	 [28672] = "Leutnant Ehran",
	 [28674] = "Feldwebel Linaarie",
	 [28693] = "Schwester der Fluten^fd",
	 [28707] = "Dralof Wassergänger",
	 [28731] = "Radrase Alen",
	 [28828] = "Imwyn Frostbaum",
	 [28852] = "Elenwen",
	 [28918] = "Sichere-Hand",
	 [28925] = "Telenger der Artefaktor",
	 [28928] = "Andewen",
	 [28930] = "Schlachtenvogt Urcelmo",
	 [28941] = "Priesterin Langwe",
	 [28959] = "Legionärin Artaste",
	 [28974] = "Angardil",
	 [28982] = "Sonya Letztblut",
	 [28993] = "Mael",
	 [28994] = "Lliae die Flinke",
	 [29008] = "Sirinque",
	 [29017] = "Bermund",
	 [29102] = "Prinz Naemon",
	 [29120] = "Caralith",
	 [29144] = "Legionärin Mincarione",
	 [29145] = "Legionär Tanacar",
	 [29146] = "Aniaste",
	 [29168] = "Unteroffizier Bredrek",
	 [29222] = "Hauptmann Tendil",
	 [29300] = "Wachthauptmann Astanya",
	 [29434] = "Holgunn Einauge",
	 [29464] = "Rellus",
	 [29604] = "Spielt-mit-Feuer",
	 [29678] = "Tabil",
	 [29782] = "Hanilan",
	 [29791] = "Ermittler Irnand",
	 [29844] = "Skalde Jakaral",
	 [29886] = "Hauptmann Henyon",
	 [29901] = "Daljari Halbtroll",
	 [29914] = "Earos",
	 [29915] = "Curime",
	 [30018] = "Widulf",
	 [30026] = "Sarisa Rothalen",
	 [30061] = "Velatosse",
	 [30069] = "Aninwe",
	 [30103] = "Iroda",
	 [30138] = "Dunkelelf",
	 [30164] = "Eminelya",
	 [30178] = "Runehild",
	 [30179] = "Logod",
	 [30183] = "Yngvar",
	 [30200] = "Hauting",
	 [30201] = "Korra",
	 [30202] = "Weise Svari",
	 [30300] = "Merormo",
	 [30307] = "Lamolime",
	 [30408] = "Eirfa",
	 [30431] = "Svein",
	 [30896] = "Baumthane Dailithil",
	 [30932] = "Halino",
	 [30933] = "Ocanim",
	 [31026] = "Hekvid",
	 [31223] = "Kapitän Khammo",
	 [31326] = "Anganirne",
	 [31327] = "Ceborn",
	 [31344] = "Feldwebel Jorald",
	 [31388] = "Tharuin die Melancholische",
	 [31416] = "Mareki",
	 [31421] = "Theofa",
	 [31429] = "Späher Arfanel",
	 [31444] = "Späherin Endetuile",
	 [31575] = "Wachmann Heldil",
	 [31639] = "Aldarchin Colaste",
	 [31746] = "Verteidiger Doppelklinge",
	 [31808] = "Gorgath Adlerauge",
	 [31837] = "Kapitän Erronfaire",
	 [31902] = "Amitra",
	 [31964] = "Borald",
	 [31967] = "Malana",
	 [31977] = "Klosterbruder Nenaron",
	 [32013] = "Mizrali",
	 [32068] = "Parmtilir",
	 [32071] = "Nilwen",
	 [32098] = "Solvar",
	 [32099] = "Hauptmann Attiring",
	 [32114] = "Odunn Grauhimmel",
	 [32172] = "Peruin",
	 [32225] = "Rolancano",
	 [32270] = "Gilien",
	 [32285] = "Fasundil",
	 [32298] = "Endaraste",
	 [32348] = "Cariel",
	 [32356] = "Leutnant Rarili",
	 [32387] = "Baham",
	 [32388] = "Brea Schneereiter",
	 [32394] = "Thragof",
	 [32495] = "Octin Murric",
	 [32496] = "Marayna Murric",
	 [32506] = "Palomir",
	 [32507] = "Rekrut Gorak",
	 [32532] = "Jurak-dar",
	 [32535] = "Bakkhara",
	 [32555] = "Spricht-mit-Lichtern",
	 [32620] = "Stöbert-in-Tiefen",
	 [32631] = "Ausbilderin Ninla",
	 [32643] = "Hauptmann Cirenwe",
	 [32649] = "Telonil",
	 [32654] = "Lerisa die Gerissene",
	 [32703] = "Alandare",
	 [32859] = "Leutnant Gustave",
	 [32861] = "Leutnant Adeline",
	 [32863] = "Hauptmann Gwyssa",
	 [32904] = "Oraneth",
	 [32946] = "Kapitän Ein-Auge",
	 [33007] = "Henilien",
	 [33013] = "Rondor",
	 [33017] = "Beobachter^md",
	 [33085] = "Hauptmann Landare",
	 [33088] = "Arelmo",
	 [33089] = "Feldwebel Artinaire",
	 [33179] = "Fürstin Elanwe",
	 [33559] = "Lisondor",
	 [33696] = "Projektion von Kireth Vanos",
	 [33806] = "Glanir",
	 [33868] = "Baumhirtin Xohaneel",
	 [33896] = "Grunyun der Schmuddelige",
	 [33938] = "Peras",
	 [33961] = "Bruchstück von Alanwe^fn",
	 [33997] = "Fürst Gharesh-ri",
	 [34268] = "Trelan",
	 [34307] = "Lugharz",
	 [34308] = "Janese Lurgette",
	 [34346] = "Suriel",
	 [34393] = "Teegya",
	 [34394] = "Sarodor",
	 [34397] = "Gathotar",
	 [34431] = "Sirdor",
	 [34438] = "Späherin Aldanya",
	 [34504] = "Skordo das Messer",
	 [34565] = "Gwilir",
	 [34566] = "Moramat",
	 [34568] = "Schamane Sumpfschwarte",
	 [34623] = "Kapitän Jimila",
	 [34646] = "Leutnant Kazargi",
	 [34733] = "Faraniel",
	 [34755] = "Tzik'nith",
	 [34817] = "Eryarion",
	 [34822] = "Nondor",
	 [34823] = "Khezuli",
	 [34824] = "Laranalda",
	 [34928] = "Ancalin",
	 [34975] = "Firtoril",
	 [34976] = "Tandare",
	 [34984] = "Neetra",
	 [34994] = "Alanwe",
	 [35004] = "Egranor",
	 [35073] = "Ordinator Areth",
	 [35257] = "Sylvian Herius",
	 [35305] = "Azum",
	 [35427] = "Endarwe",
	 [35432] = "Dulini",
	 [35492] = "Vyctoria Girien",
	 [35510] = "Konstabler Charlic",
	 [35859] = "Neramo",
	 [35873] = "Dugroth",
	 [35897] = "Tharayya",
	 [35918] = "Akolythin Eldri",
	 [36093] = "Kapitän Linwen",
	 [36102] = "Englor",
	 [36113] = "Pirondil",
	 [36115] = "Khali",
	 [36116] = "Shazah",
	 [36119] = "Engor",
	 [36129] = "Aniel",
	 [36187] = "Wachposten Beriel",
	 [36188] = "Wachposten Rechiche",
	 [36280] = "Decius",
	 [36290] = "Sigunn",
	 [36294] = "Medveig",
	 [36295] = "Helfhild",
	 [36356] = "Azlakha",
	 [36584] = "Schamane Glazulg",
	 [36598] = "Kapitän Kaleen",
	 [36599] = "Jakarn",
	 [36611] = "Stallmagd",
	 [36632] = "Tevynni Hedran",
	 [36654] = "Jilan-dar",
	 [36913] = "Liane",
	 [36916] = "Lambur",
	 [36971] = "Irien",
	 [36985] = "Lehrling Savur",
	 [37058] = "Rozag gro-Khazun",
	 [37059] = "Frederique Lynielle",
	 [37096] = "Talres Voren",
	 [37181] = "Unteroffizierin Anerel",
	 [37391] = "Andrilion",
	 [37396] = "Nicolene",
	 [37461] = "Häuptling Tazgol",
	 [37534] = "Laganakh",
	 [37593] = "Milchauge",
	 [37595] = "Ezzag",
	 [37596] = "Kalari",
	 [37727] = "Späherin Mengaer",
	 [37900] = "Hlenir Redoran",
	 [37976] = "Zenturio Burri",
	 [37978] = "Präfektin Antias",
	 [37985] = "Tazia",
	 [37986] = "Calircarya",
	 [37987] = "Berdonion",
	 [37988] = "Ghadar",
	 [37996] = "Gugnir",
	 [38032] = "Malfinir",
	 [38043] = "Shazeem",
	 [38047] = "Ufgra gra-Gum",
	 [38057] = "Daine",
	 [38077] = "Siraj",
	 [38093] = "Leutnant Clarice",
	 [38116] = "Feldwebel Muzbar",
	 [38181] = "Nilaendril",
	 [38182] = "Feldwebel Dagla",
	 [38201] = "Matys Derone",
	 [38217] = "Ongalion",
	 [38251] = "Gruluk gro-Khazun",
	 [38269] = "Kaut-am-Schwanz",
	 [38302] = "Herzog Nathaniel",
	 [38303] = "Aemilia Hadrianus",
	 [38329] = "Ozozur",
	 [38346] = "Sir Hughes",
	 [38373] = "Zal-sa",
	 [38407] = "Bataba",
	 [38413] = "Schlachtenvogt Alduril",
	 [38494] = "Suronii",
	 [38498] = "Azahrr",
	 [38532] = "Mezha-dro",
	 [38649] = "Indaenir",
	 [38650] = "Bodring",
	 [38852] = "Magula",
	 [38856] = "Feldwebel Irinwen",
	 [38863] = "Feldwebel Farya",
	 [38969] = "Mondbischof Hunal",
	 [38974] = "Marius",
	 [38979] = "Erranenen",
	 [38984] = "Angwe",
	 [38996] = "Gordag",
	 [39037] = "Hjorik",
	 [39166] = "Zahra",
	 [39189] = "Ehtayah",
	 [39191] = "Felari",
	 [39202] = "Remy Berard",
	 [39330] = "Jagdweib Lurgush",
	 [39336] = "Grigerda",
	 [39459] = "Benduin",
	 [39465] = "Orthenir",
	 [39475] = "Yanaril",
	 [39483] = "Baumthane Fariel",
	 [39505] = "Baumthane Niriel",
	 [39542] = "Zadala",
	 [39562] = "Fongoth",
	 [39579] = "Nara",
	 [39613] = "Hazazi",
	 [39623] = "Ofglog gro-Borkenbiss",
	 [39706] = "Späher Schneejäger",
	 [39729] = "Ukatsei",
	 [39771] = "Uggissar",
	 [39774] = "Hojard",
	 [39782] = "gerissener Tom",
	 [39790] = "Garnikh",
	 [39954] = "Wachhauptmann Zafira",
	 [40105] = "Sind",
	 [40118] = "Halindor",
	 [40119] = "Baumthane Bowenas",
	 [40266] = "Dulan",
	 [40375] = "Stadtwahrerin^fd",
	 [40395] = "Bunul",
	 [40554] = "Khaba",
	 [40577] = "Heluin",
	 [40578] = "Mel Adrys",
	 [40684] = "Feldwebel Firion",
	 [40712] = "Armin",
	 [40755] = "Leono Draconis",
	 [40849] = "Gathwen",
	 [40903] = "Gadris",
	 [41027] = "Sylvain Quintin",
	 [41044] = "Anglorn",
	 [41091] = "Späher Ruluril",
	 [41115] = "Shatasha",
	 [41116] = "Rasha",
	 [41160] = "Zaeri",
	 [41191] = "Kazirra",
	 [41205] = "Balag",
	 [41207] = "Feluni",
	 [41233] = "Rathisa die Schlitzerin",
	 [41235] = "Thorinor",
	 [41385] = "Zulana",
	 [41387] = "Estinan",
	 [41389] = "Cartirinque",
	 [41397] = "Tertius Falto",
	 [41418] = "Gungrim",
	 [41425] = "Weberin Benieth",
	 [41480] = "Mansa",
	 [41506] = "Saldir",
	 [41511] = "Edheldor",
	 [41547] = "Eliana Salvius",
	 [41549] = "Talania Priscus",
	 [41560] = "Marimah",
	 [41634] = "Malkur Valos",
	 [41644] = "Apphia Matia",
	 [41788] = "Weber Maruin",
	 [41887] = "Juranda-ra",
	 [41890] = "Zunderschwanz",
	 [41928] = "Yahyif",
	 [41929] = "Eneriell",
	 [41934] = "Azbi-ra",
	 [41947] = "Priesterin Sendel",
	 [42130] = "Offizierin Lorin",
	 [42297] = "Arcarin",
	 [42332] = "Zan",
	 [42346] = "verdächtiger Affe",
	 [42461] = "Fabanil",
	 [42500] = "Kauzanabi-jo",
	 [42520] = "Krodak",
	 [42555] = "Darius",
	 [42576] = "Olvyia Indaram",
	 [42577] = "Spiegel-Schuppe",
	 [42578] = "Adalmor",
	 [42579] = "Veronard Liancourt",
	 [42584] = "Bugbesh",
	 [42922] = "Hexer Carindon",
	 [42928] = "Jagnas",
	 [42929] = "Hauptmann Sarandil",
	 [43049] = "Melrethel",
	 [43094] = "Hadam-do",
	 [43163] = "Major Cirenwe",
	 [43242] = "Bootsmann Knochen",
	 [43247] = "Ragalvir",
	 [43321] = "Dralnas Moryon",
	 [43334] = "Galbenel",
	 [43360] = "Kanniz",
	 [43401] = "Jeromec Lemal",
	 [43519] = "Wildkönig^md",
	 [43622] = "Wildkönigin^fd",
	 [43657] = "Lekis Jünger^Mg",
	 [43719] = "Firiliril",
	 [43782] = "Fatahala",
	 [43839] = "Kurzer-Schwanz",
	 [43942] = "Meriq",
	 [43948] = "Aqabi von den Götterlosen",
	 [44036] = "mächtige Mordra",
	 [44059] = "Offizierin Parwinel",
	 [44100] = "Uhrih",
	 [44127] = "Thonoras",
	 [44153] = "Dringoth",
	 [44280] = "Projektion von Vanus Galerion",
	 [44283] = "Rollin",
	 [44302] = "Gilraen",
	 [44485] = "Elaldor",
	 [44502] = "Sorderion",
	 [44625] = "Lataryon",
	 [44665] = "Nellor",
	 [44679] = "Haras",
	 [44697] = "Laurosse",
	 [44707] = "Erinel",
	 [44709] = "Egannor",
	 [44731] = "Dinwenel",
	 [44741] = "Taralin",
	 [44855] = "Kaltauge",
	 [44856] = "Kunira-daro",
	 [44861] = "Marisette",
	 [44864] = "Sumiril",
	 [44894] = "Cinnar",
	 [44899] = "Nivrilin",
	 [45170] = "Gamirth",
	 [45200] = "Thalara",
	 [45458] = "Alandis",
	 [45475] = "Galsi Mavani",
	 [45641] = "Aurorelle Varin",
	 [45645] = "Gasteau Chamrond",
	 [45688] = "Adamir",
	 [45723] = "Wilminn",
	 [45725] = "Zimar",
	 [45744] = "Soldatin Alque",
	 [45745] = "Soldatin Cularalda",
	 [45757] = "Narion",
	 [45759] = "Ledronor",
	 [45845] = "Radreth",
	 [45909] = "Glaras",
	 [45953] = "Eringor",
	 [46174] = "Anenya",
	 [46204] = "Curinure",
	 [46241] = "Aicessar",
	 [46323] = "Zaddo",
	 [46439] = "Valarril",
	 [46520] = "Adusa-daro",
	 [46595] = "Daribert Hurier",
	 [46655] = "Ancalmo",
	 [46700] = "Fingaenion",
	 [47088] = "Gluineth",
	 [47445] = "Feldwebel Sgugh",
	 [47472] = "Soldatin Garion",
	 [47473] = "Hauptmann Elonthor",
	 [47631] = "Gwendis",
	 [47667] = "Sebazi",
	 [47677] = "Zaag",
	 [47685] = "Arkas",
	 [47686] = "Ikran",
	 [47754] = "Jean-Jacques Alois",
	 [47765] = "Rafora Casca",
	 [47770] = "Enda",
	 [47854] = "Leutnant Ergend",
	 [47924] = "Llotha Nelvani",
	 [48009] = "Brelor",
	 [48092] = "Gahgdar",
	 [48116] = "Githiril",
	 [48295] = "Feldwebel Antieve",
	 [48567] = "Hauptmann Eugien Gaerfeld",
	 [48570] = "Bistrand Giroux",
	 [48573] = "Wyrdin Delphique",
	 [48660] = "Enthoras",
	 [48891] = "Teeba-Ja",
	 [48893] = "Hochordinator Danys",
	 [48916] = "Sabonn",
	 [48996] = "Irrauge",
	 [49030] = "Forinor",
	 [49180] = "Nathalye Ervine",
	 [49189] = "Alvaren Garoutte",
	 [49284] = "Wyrdin Linnae",
	 [49349] = "Mizahabi",
	 [49408] = "Beryn",
	 [49410] = "König Camoran Aeradan",
	 [49432] = "Mendil",
	 [49482] = "Orthelos",
	 [49534] = "Herminius Sophus",
	 [49608] = "Archimbert Dantaine",
	 [49624] = "Maenlin",
	 [49646] = "Lashgikh",
	 [49669] = "Nichts^n",
	 [49698] = "Cirmo",
	 [49708] = "Adainurr",
	 [49709] = "Meleras",
	 [49743] = "Najan",
	 [49778] = "Hüter der Halle",
	 [49863] = "Thoreki",
	 [49898] = "Gelehrter Cantier",
	 [49926] = "Gerweruin",
	 [49955] = "Klingenmeister Qariar",
	 [49958] = "Glothorien",
	 [49985] = "Sarandel",
	 [50037] = "Vorundil",
	 [50091] = "Eminaire",
	 [50141] = "Caesonia",
	 [50228] = "Turshan-dar",
	 [50233] = "Hauptmann Wardush",
	 [50237] = "Hauptmann Gemelle",
	 [50416] = "Semusa",
	 [50525] = "Afwa",
	 [50550] = "Kailstig die Axt",
	 [50639] = "Skelett^n",
	 [50684] = "Lange-Form",
	 [50765] = "Turuk Rotkrallen",
	 [50990] = "Angamar",
	 [51086] = "Malma",
	 [51088] = "Brendar",
	 [51134] = "Israk Eissturm",
	 [51310] = "Hauptmann Thayer",
	 [51397] = "Titus Valerius",
	 [51461] = "Frederic Seychelle",
	 [51615] = "Sadaifa",
	 [51842] = "Vaerarre",
	 [51901] = "Diebin^fd",
	 [51963] = "Sterngucker-Herold",
	 [52071] = "Erold",
	 [52096] = "Dathlyn",
	 [52103] = "Caalorne",
	 [52105] = "Hjagir",
	 [52118] = "Sieht-viele-Pfade",
	 [52166] = "Shuldrashi",
	 [52169] = "Arethil",
	 [52181] = "Parquier Gimbert",
	 [52291] = "Feldwebel Oorga",
	 [52731] = "Hohlen-Wächter",
	 [52741] = "Genthel",
	 [52751] = "Firtorel",
	 [52752] = "König Laloriaran Dynar",
	 [52753] = "Aerona Berendas",
	 [52929] = "Klosterschwester Tanaame",
	 [52930] = "Klosterschwester Firinore",
	 [52931] = "Nilyne Hlor",
	 [53979] = "Wachmann Cirdur",
	 [53980] = "Aldunie",
	 [53983] = "Hartmin",
	 [54043] = "Gorvyn Dran",
	 [54049] = "Greban",
	 [54154] = "Umbarile",
	 [54228] = "Nazdura",
	 [54410] = "Fada at-Glina",
	 [54577] = "Rekrutin Maelle",
	 [54580] = "Ibrula",
	 [54848] = "königliche Botin",
	 [55120] = "Unteroffizier Adel",
	 [55125] = "Lodiss",
	 [55221] = "Ralai",
	 [55270] = "Kämpft-mit-Schwanz",
	 [55351] = "Sara Benele",
	 [55378] = "Nhalan",
	 [56177] = "Sternguckerin Nudryn",
	 [56248] = "mächtige Mordra",
	 [56459] = "Mihayya",
	 [56501] = "Safa al-Satakalaam",
	 [56503] = "Verstreutes-Laub",
	 [56504] = "Lashburr Zahnbrecher",
	 [56513] = "Kapitän Tremouille",
	 [56525] = "Riurik",
	 [56701] = "Thalinfar",
	 [57474] = "Regentin Cassipia",
	 [57577] = "Nendirume",
	 [57649] = "Kleinblatt",
	 [57850] = "Atildel",
	 [58495] = "Glaubenskrieger Dalamar",
	 [58640] = "Mederic Vyger",
	 [58826] = "Maj al-Ragath",
	 [58841] = "Glirion der Rotbart",
	 [58889] = "Millenith",
	 [59027] = "himmlischer Krieger^mdc",
	 [59046] = "Danel Telleno",
	 [59335] = "Orgotha",
	 [59362] = "Fedar Githrano",
	 [59388] = "Glurbasha",
	 [59604] = "Cinosarion",
	 [59685] = "Schmiedemutter Alga",
	 [59780] = "Dirdre",
	 [59840] = "Schmiedeweib Kharza",
	 [59873] = "Archivarin Murboga",
	 [59900] = "Rogzesh",
	 [59908] = "Laurig",
	 [59963] = "Häuptling Bazrag",
	 [60187] = "Schwester Terran Arminus",
	 [60285] = "Adara'hai",
	 [64703] = "Mazgroth",
	 [64741] = "Schildweib Razbela",
	 [64769] = "Lazghal",
	 [64805] = "Eveli Scharfpfeil",
	 [64864] = "Meram Farr",
	 [64891] = "Fürst Ethian",
	 [65199] = "Fa-Nuit-Hen",
	 [65239] = "Talviah Aliaria",
	 [65270] = "Brulak",
	 [65296] = "Nashruth",
	 [65444] = "Lozruth",
	 [65634] = "Orzorga",
	 [65717] = "Zabani",
	 [65736] = "Mulzah",
	 [65951] = "Kuratorin Umutha",
	 [66284] = "Kyrtos",
	 [66293] = "Youss",
	 [66310] = "Dagarha",
	 [66412] = "Nammadin",
	 [66701] = "Doranar",
	 [66830] = "Häuptling Urgdosh",
	 [66840] = "Eshir",
	 [66846] = "Zinadia",
	 [67016] = "Borfree Stumpfklinge",
	 [67018] = "Arzorag",
	 [67019] = "Guruzug",
	 [67033] = "Drudun",
	 [67826] = "Grazda",
	 [67828] = "Astara Caerellius",
	 [67843] = "Sprecher Terenus",
	 [68132] = "Zeira",
	 [68328] = "Quen",
	 [68594] = "Shalug der Hai",
	 [68654] = "Rohefa",
	 [68688] = "Bakhum",
	 [68825] = "Thrag",
	 [68884] = "Stuga",
	 [69048] = "Andarri",
	 [69081] = "Sabileh",
	 [69142] = "Lund",
	 [69854] = "Spencer Rye",
	 [70383] = "Quen",
	 [70459] = "Elam Drals",
	 [70472] = "Nevusa",
	 [72001] = "Amelie Kroh",
    -- Shar Morrowind
    -- Shar Crown Store
    -- Shar Misc
    -- Shar Elsweyr
	 [81000] = "Nisuzi",
    -- Shar Skyrim
    -- Summerset
    -- Clockwork City
    -- New auto created
    [100026] = "Renzir",
    [100078] = "Sheogorath",
    [100086] = "Sarazi",
    [100092] = "Elhalem",
    [100111] = "Ri'hirr",
    -- Skyrim
    [200004] = "Schwertthane Jylta",
    [200005] = "Verita Numida",
    [200006] = "Hidaver",
    [200007] = "Tinzen",
    [200012] = "Deckarbeiter Bazler",
    [200013] = "Evska",
    [200021] = "Relmerea Sethandus",
    [200028] = "Rafilerrion",
    -- Existing
	[500000] = "Ayleïdensarkophag",
	[500001] = "Heist Board",
	[500002] = "Reacquisition Board",
	[500003] = "Eintrag in Tharayyas Tagebuch: 10",
	[500004] = "Eintrag in Tharayyas Tagebuch: 2",
	[500005] = "Schuldschein",
	[500006] = "Brief an Tavo",
	[500007] = "Brief an Fadeel",
	[500008] = "Altmerisches Relikt",
	[500009] = "Handwerksschriebe: Ausrüstung",
	[500010] = "Handwerksschriebe",
	[500011] = "Blutiges Tagebuch",
	[500012] = "Mages Guild Handbill",
	[500013] = "Gefaltete Notiz",
	[500014] = "Transportliste",
	[500015] = "Doctor's Bag",
	[500016] = "Crate",
	[500017] = "Letter",
	[500018] = "Nasser Beutel",
	[500019] = "Notebook",
	[500020] = "Message to Jena",
	[500021] = "Weathered Notes",
	[500022] = "Letter to Belya",
	[500023] = "Kiste",
	[500024] = "Notiz",
	[500025] = "Tagebuchseite",
	[500026] = "Brief von Historiker Maaga",
	[500027] = "Einladung in die Unerschrockene Enklave",
	[500028] = "Befehle von Großkomtur Varaine",
	[500029] = "Pelorrahs Forschungsnotizen",
	[500030] = "Liefervertrag",
	[500031] = "A Dire Warning",
	[500032] = "Banditen-Notiz",
	[500033] = "Lagerfeuer",
	[500034] = "Daedrische Urne",
	[500035] = "Anhänger",
	[500036] = "Zurückgelassenes Gepäck",
	[500037] = "Hastig verfasste Notiz",
	[500038] = "Idrias Laute",
	[500039] = "Nettiras Tagebuch",
	[500040] = "Notiz eines Winterkinds",
	[500041] = "Der Graue Lauf",
	[500042] = "Orrery",
	[500043] = "Centurion Control Lexicon",
	[500044] = "Unusual Stone Carving",
	[500045] = "Forschungsnotizen zur Trollsozialisierung",
	[500046] = "Gekritzelte Notiz",
	[500047] = "Fighters Guild Handbill",
	[500048] = "Bandit Note",
	[500049] = "Verbeulter Schild",
	[500050] = "Risas Tagebuch",
	[500051] = "Eine angemessene Warnung",
	[500052] = "Sprechender Stein",
	[500053] = "Staubige Schriftrolle",
	[500054] = "Begräbnisurne",
	[500055] = "Werbeschreiben",
	[500056] = "Uralte nordische Begräbnisurne",
	[500057] = "Begräbnisurne",
	[500058] = "Handres letzter Wille",
	[500059] = "Verdächtiges Fässchen",
	[500060] = "Späherbefehle",
	[500061] = "Rotkrähen-Notiz",
	[500062] = "Guifford Vinielles Skizzenbuch",
	[500063] = "Banditentagebuch",
	[500064] = "Runensteinfragment",
	[500065] = "Zerrissener Brief",
	[500066] = "Nimriells Forschungsunterlagen",
	[500067] = "Azuras Schrein",
	[500068] = "Storghs Bogen",
	[500069] = "Mercanos Tagebuch",
	[500070] = "Rucksack",
	[500071] = "Nadafas Tagebuch",
	[500072] = "Merkwürdiger Sprössling",
	[500073] = "Kunderschaftertafel",
	[500074] = "Bosmervase",
	[500075] = "Tagebuch eines Z'en-Priesters",
	[500076] = "Durchnässtes Tagebuch",
	[500077] = "Moranda-Edelsteingitter",
	[500078] = "Graccus' Tagebuch,	Band 2",
	[500079] = "Staubiges Instrument",
	[500080] = "Macht die Wildnis sicherer und verdient Euch auch noch Gold dabei",
	[500081] = "Yenadars Tagebuch",
	[500082] = "Verdächtige Flasche",
	[500083] = "Eine uralte Schriftrolle",
	[500084] = "Klaandors Tagebuch",
	[500085] = "Nedras' Tagebuch",
	[500086] = "Uraltes Schwert",
	[500087] = "Schwert",
	[500088] = "Der Tempel von Sul",
	[500089] = "Merkwürdiges Gerät",
	[500090] = "Warnung",
	[500091] = "Angriffspläne",
	[500092] = "Verwitterte Truhe",
	[500093] = "Verfluchter Schädel",
	[500094] = "Letzter Wille und Testament von Frodibert Fontbonne",
	[500095] = "Gestohlene Waren",
	[500096] = "Freigelegte Truhe",
	[500097] = "Frostheart Blossom",
	[500098] = "Zeremonienschriftrolle",
	[500099] = "Uralte Schriftrolle",
	[500100] = "Pakt-Amulett",
	[500101] = "Offer of Amnesty",
	[500102] = "Agolas' Tagebuch",
	[500103] = "Old Pack",
	[500104] = "To the Hero of Wrothgar!",
	[500105] = "Haus des Ruhms der Orsimer",
	[500106] = "Note from Velsa",
	[500107] = "Tip Board",
	[500108] = "Note from Quen",
	[500109] = "Note from Zeira",
	[500110] = "Note from Walks-Softly",
	[500111] = "Message from Walks-Softly",
	[500112] = "Message from Velsa",
	[500113] = "Diebesgilde^fd",
	[500114] = "Magiergilde^fd",
	[500115] = "Kriegergilde^fd",
	[500116] = "Unerschrockene^pd",
	[500117] = "Hut von Julianos",
	[500118] = "Kopfgeldtafel",
	[500119] = "dunkle Bruderschaft^fdc",
	[500120] = "Zum Tode auserkoren",
	[500121] = "Note from Astara",
	[500122] = "Note from Kor",
	[500123] = "Azaras Notiz",
}