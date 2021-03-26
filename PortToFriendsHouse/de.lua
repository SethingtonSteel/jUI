-- PortToFriendsHouse
-- By @s0rdrak (PC / EU)

local PortToFriend = _G['PortToFriend']

PortToFriend.HOUSES =
{
    [1] = "Gästezimmer Maras Kuss",
    [2] = "Zum Rosenlöwen",
    [3] = "Zur Ebenholzflasche",
    [4] = "Privatraum im Widerhaken",
    [5] = "Zimmer der Sande",
    [6] = "Luxusmansarde des Nix ",
    [7] = "Schwarzrebenvilla",
    [8] = "Klippschatten",
    [9] = "Mathiisen-Herrenhaus",
    [10] = "Demutschlamm",
    [11] = "Geräumiges Domizil",
    [12] = "Anwesen Bleibt-Feucht",
    [13] = "Kuschelkapsel",
    [14] = "Felsbaumzuflucht",
    [15] = "Gorinir-Anwesen",
    [16] = "Kapitän Margaux' Heim",
    [17] = "Rabenwäldchen",
    [18] = "Gardnerhaus",
    [19] = "Kragenheim",
    [20] = "Velothiträumerei",
    [21] = "Quondam Indorilia",
    [22] = "Mondfreudehaus",
    [23] = "Glattbachhaus",
    [24] = "Dämmerschatten",
    [25] = "Cyrodiilisches Dschungelhaus",
    [26] = "Domus Phrasticus",
    [27] = "Stridquelldomäne",
    [28] = "Herbsttor",
    [29] = "Grymharths Wehe",
    [30] = "Altes Nebelschleier-Herrenhaus",
    [31] = "Hammertod-Sommerhaus",
    [32] = "Feste Gramen",
    [33] = "Aufgegebene Festung",
    [34] = "Zwillingsbogen",
    [35] = "Haus des leisen Magnifico",
    [36] = "Hundings Prunkhalle",
    [37] = "Gelasssenheitsfälle-Anwesen",
    [38] = "Dolchsturz-Ausblick",
    [39] = "Ebenherz-Château",
    [40] = "Großes Topalversteck",
    [41] = "Erdtränen-Kavernen",
    [42] = "Apartment im Heilligen Deylen",
    [43] = "Das Amayassee-Herrenhaus",
    [44] = "Das Hafenhaus in Ald Velothi",
    [45] = "Der Turm von Tel Galen",
	[46] = "Das Linchal-Großanwesen",
	[47] = "Das surealle Fleckchen",
	[48] = "Hakkvilds hohe Halle",
	[49] = "Verlassene Hexenhütte",
	[54] = "Der Gipfel des Ausgestoßenen",
	[55] = "Das erste Sphäratorium",
	[56] = "Ehemalige Freistatt",
	[57] = "Der Prinzliche Dämmerlichtpalast",
	[58] = "Die Mansarde im \"Goldenen Greifen\"",
	[59] = "Alinor-Stadtgrathaus",
	[60] = "Kolossale aldmerische Grotte",
	[61] = "Die Lichtung des Jägers",
	[62] = "Große Psijik-Villa",
	[63] = "Verzaubertes Schneekugelheim",
	[64] = "Die Seemoor-Xanmeer",
	[65] = "Die Frostgewölbekluft",
	[66] = "Die Elinhir-Privatarena",
	[68] = "Das Zuckerschlüsselgemach",
	[69] = "Jodes Umarmung",
	[70] = "Die Halle des Mondchampions",
	[71] = "Die Mondzuckeraue",
	[72] = "Schemenheim",
	[73] = "Die Vier-Pfoten-Landung",
	[74] = "Rückzugsort des Potentaten",
	[75] = "Die Schmiedemeisterfälle",
	[76] = "Die Oase der Diebe",
	[77] = "Die Schneeschmelz-Suite",
	[78] = "Stolzspitze-Herrenhaus",
	[79] = "Die Bastion Sanguinaris",
	[80] = "Rückzugsort \"Stilles Wasser\"",
	[81] = "Die Berggalerie des Antiquars"
}
PortToFriend.constants.HEADER_TITLE = "Port to Friend's House"
PortToFriend.constants.LABEL_PLAYER = "Spieler:"
PortToFriend.constants.BUTTON_PORT = "Porten"
PortToFriend.constants.BUTTON_ADD_FAVORITE = "Hinzufügen"
PortToFriend.constants.BUTTON_SEND_VISITCARD = "Visitenkarte senden"
PortToFriend.constants.BUTTON_MAIN_RESIDENCE = "Hauptwohnsitz"
PortToFriend.constants.VC_HEADER_TITLE = "Visitenkarten"
PortToFriend.constants.VC_PLAYER = "Spieler: "
PortToFriend.constants.VC_HOUSE = "Haus: "
PortToFriend.constants.BUTTON_REMOVE = "Entfernen"
PortToFriend.constants.BUTTON_VC = "VC"
PortToFriend.constants.TOGGLE_PORT_WINDOW = "Port to Friend's House Fenster öffnen"
PortToFriend.constants.PORT_TO_FAVORITE = "Zu Favorit #%d porten"
PortToFriend.constants.INVALID_FAVORITE_ID = "Es wurde eine ungültige ID angegeben"
PortToFriend.constants.SORT_NAME = "Spieler"
PortToFriend.constants.SORT_HOUSE = "Haus"
PortToFriend.constants.CMD_HELP_1 = " open: Öffnet das Port to Friend's House Menü"
PortToFriend.constants.CMD_HELP_2 = " show: Zeigt eine Liste mit allen möglichen Häusern und deren ID an. Die ID ist optional."
PortToFriend.constants.CMD_HELP_3 = " port <player> <ID>: Versucht zum angegebenen Haus zu porten"
PortToFriend.constants.CMD_HELP_4 = " fav <ID>: Zu Favorit <ID> porten"
PortToFriend.constants.TAB_HOUSE_TITLE = "Häuser"
PortToFriend.constants.TAB_VC_TITLE = "Visitenkarten"
PortToFriend.constants.TAB_LIBRARY_TITLE = "Bibliothek"
PortToFriend.constants.TAB_DONATE_TITLE = "Spenden"
PortToFriend.constants.DONATION_WRONG_SERVER = "Danke für die Erwägung einer Goldspende.\r\nEs macht jedoch keinen Sinn mir Gold zu schicken, da wir auf unterschiedlichen Servern spielen."
PortToFriend.constants.DONATION_MESSAGE = "Danke für die Erwägung einer Goldspende."
PortToFriend.constants.BUTTON_DONATION_PERSONAL = "Spenden"
PortToFriend.constants.BUTTON_DONATION_5 = "5'000 Gold spenden"
PortToFriend.constants.BUTTON_DONATION_50 = "50'000 Gold spenden"
PortToFriend.constants.DONATE_MAIL_SUBJECT = "PortToFriend-Spende"
PortToFriend.constants.LIBRARY_MESSAGE = "Die Bibliothek beinhaltet Spielerhäuser. Falls du dein Haus in dieser Liste sehen willst, dann hinterlass einen Kommentar in einem PTF Thread im ESO Forum oder ESOUI (AddOn Kommentar)."
PortToFriend.constants.FILTER_LABEL = "Kategorienfilter"
PortToFriend.constants.FILTER_NONE = "--KEINE--"
PortToFriend.constants.FILTER_HIGHLIGHT = "Highlight"
PortToFriend.constants.FILTER_LABYRINTH = "Labyrinth"
PortToFriend.constants.FILTER_JUMPNRUN = "Jump 'n' Run"
PortToFriend.constants.FILTER_CRAFTING = "Handwerk / Mundus"
PortToFriend.constants.FILTER_GUILD = "Gildenhalle"
PortToFriend.constants.FILTER_ROLEPLAY = "Roleplay"
PortToFriend.constants.FILTER_RAID = "Raid / DPS"
PortToFriend.constants.FILTER_HIDE_SEEK = "Versteckspiel"
PortToFriend.constants.FILTER_ERP = "ERP"

PortToFriend.constants.menu = {}
PortToFriend.constants.menu.DISPLAY_NAME = "|c4592FFPort To Friend's House Configuration|r"
PortToFriend.constants.menu.AUTHOR = string.format("|cFF8174%s|r\r\nThanks to: |cFF8174%s|r\r\n", PortToFriend.author, PortToFriend.credits)
PortToFriend.constants.menu.VERSION = string.format("|cFF8174%s|r", PortToFriend.versionString)
PortToFriend.constants.menu.TITLE = "Chat Konfiguration"
PortToFriend.constants.menu.DESCRIPTION = "Konfiguriere die Chats, die Visitenkarten hinzufügen dürfen"

PortToFriend.constants.menu.G1 = "Gilde 1"
PortToFriend.constants.menu.O1 = "Offiziere 1"
PortToFriend.constants.menu.G2 = "Gilde 2"
PortToFriend.constants.menu.O2 = "Offiziere 2"
PortToFriend.constants.menu.G3 = "Gilde 3"
PortToFriend.constants.menu.O3 = "Offiziere 3"
PortToFriend.constants.menu.G4 = "Gilde 4"
PortToFriend.constants.menu.O4 = "Offiziere 4"
PortToFriend.constants.menu.G5 = "Gilde 5"
PortToFriend.constants.menu.O5 = "Offiziere 5"
PortToFriend.constants.menu.EMOTE = "Aktionen"
PortToFriend.constants.menu.SAY = "Sagen"
PortToFriend.constants.menu.YELL = "Rufen"
PortToFriend.constants.menu.GROUP = "Gruppe"
PortToFriend.constants.menu.TELL = "Flüstern"
PortToFriend.constants.menu.ZONE = "Gebiet"
PortToFriend.constants.menu.ENZONE = "Gebiet - English"
PortToFriend.constants.menu.FRZONE = "Gebiet - French"
PortToFriend.constants.menu.DEZONE = "Gebiet - German"
PortToFriend.constants.menu.JPZONE = "Gebiet - Japan"
PortToFriend.constants.menu.ALLOW_SELF = "Erlaube Selbst-VC"

PortToFriend.constants.CONTEXT_MENU_SEND = "An PTF senden"