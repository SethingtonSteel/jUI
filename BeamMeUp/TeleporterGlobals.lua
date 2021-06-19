Teleporter = {}

Teleporter.win =   {
      Main_Control = {},
}

Teleporter.var = {
  appName               = "BeamMeUp",
  appNameAbbr			= "BMU",
  version				= "", -- Will be set by help of function GetAddonVersionFromManifest(), see file BeamMeUp.lua event_add_on_loaded
  author				= "DeadSoon, Gamer1986PAN",
  website				= "https://www.esoui.com/downloads/info2143-BeamMeUp-TeleporterFastTravel.html",
  feedback				= "https://www.esoui.com/portal.php?id=283&a=faq", -- FAQ link
  controls              = {},
  welcomeMsg            = "",
  loadMessageInterval   = 5,
  isAddonLoaded         = false,
  color                 = {
    colMagic     = "|c2dc50e", -- Magic Green (Uncommon)
    colTrash     = "|c777777", -- Trash Gray
    colYellow    = "|cFFFF00" ,-- yellow
    colArcane    = "|c3689ef", -- Arcane Blue (Rare)
    colArtifact  = "|c912be1", -- Epic (Epic)
    colTeal      = "|c00FFFF", -- teal
    colWhite     = "|cFFFFFF", -- white
    colRed       = "|cFF0000", -- Red
    colLegendary = "|cd5b526", -- Legendary Gold (TheShit)
    colGreen     = "|c00FF00", -- green
	colOrange    = "|cfd7a1a", -- orange
	colBlue		 = "|c75bac1", -- blue (for repeatable quests)
	colDarkRed	 = "|ca20000", -- dark red (for unrelated quests)
	colGray		 = "|c8c8c8c", -- gray for placeholder
  },
  BMUGuilds = {
	["EU Megaserver"] = {569082, 582568, 620882, 633582},
	["NA Megaserver"]	= {591705, 666643, 708141, 720529},
  },
  partnerGuilds = {
 	["EU Megaserver"] = {635942, 570448, 7871, 631764, 661070, 389326, 634734, 677494, 418220, 649984},
	["NA Megaserver"]	= {698893, 601183, 738065, 738317, 630823, 677323, 704951, 785051},
  },
  guildHouse			= {
	-- displayName and houseId
	["EU Megaserver"]	= {"@DeadSoon", 81},
	["NA Megaserver"]	= {"@ZoLatKam", 62},
  },
  playerName = ""
}

-- Libraries
Teleporter.LibDialog = LibDialog
if Teleporter.LibDialog == nil then 
	if LibStub then
		Teleporter.LibDialog = LibStub('LibDialog', true)
	else
		d("[" .. Teleporter.var.appName .. " - ERROR] unable to load library LibDialog")
	end
end

Teleporter.LibZone = LibZone
if Teleporter.LibZone == nil then 
	if LibStub then
		Teleporter.LibZone = LibStub('LibZone', true)
	else
		d("[" .. Teleporter.var.appName .. " - ERROR] unable to load library LibZone")
	end
end

Teleporter.LAM = LibAddonMenu2
if Teleporter.LAM == nil then 
	if LibStub then
		Teleporter.LAM = LibStub('LibAddonMenu-2.0', true)
	else
		d("[" .. Teleporter.var.appName .. " - ERROR] unable to load library LibAddonMenu-2.0")
	end
end

Teleporter.LSC = LibSlashCommander
if Teleporter.LSC == nil then 
	if LibStub then
		Teleporter.LSC = LibStub('LibSlashCommander', true)
	else
		d("[" .. Teleporter.var.appName .. " - ERROR] unable to load library LibSlashCommander")
	end
end

-- Textures
Teleporter.textures = {
	tooltipSeperator = "|t120:5:esoui/art/guild/sectiondivider_left.dds|t",
	anchorMapBtn = "/BeamMeUp/media/dock.dds",
	anchorMapBtnOver = "/BeamMeUp/media/dock_over.dds",
	lockClosedBtn = "/BeamMeUp/media/lock_closed.dds",
	lockClosedBtnOver = "/BeamMeUp/media/lock_closed_over2.dds",
	lockOpenBtn = "/BeamMeUp/media/lock_open.dds",
	lockOpenBtnOver = "/BeamMeUp/media/lock_open_over2.dds",
	swapBtn = "/BeamMeUp/media/swap.dds",
	swapBtnOver = "/BeamMeUp/media/swap_over.dds",
	closeBtn = "/BeamMeUp/media/close.dds",
	closeBtnOver = "/BeamMeUp/media/close_over.dds",
	feedbackBtn = "/esoui/art/mail/mail_tabicon_compose_up.dds",
	feedbackBtnOver = "/esoui/art/mail/mail_tabicon_compose_down.dds",
	searchBtn = "/BeamMeUp/media/tradinghouse_browse_tabicon.dds",
	searchBtnOver = "/BeamMeUp/media/tradinghouse_browse_tabicon_over.dds",
	refreshBtn = "/BeamMeUp/media/gp_radialicon_trade.dds",
	refreshBtnOver = "/BeamMeUp/media/gp_radialicon_trade_over.dds",
	questBtn = "/BeamMeUp/media/quest.dds",
	questBtnOver = "/BeamMeUp/media/quest_over.dds",
	wayshrineBtn = "/BeamMeUp/media/poi_wayshrine_complete.dds",
	wayshrineBtnOver = "/BeamMeUp/media/poi_wayshrine_complete_over.dds",
	-- wayshrine button texture with event cycle
	wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete.dds",
	wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over.dds",
	settingsBtn = "/BeamMeUp/media/menubar_mainmenu.dds",
	settingsBtnOver = "/BeamMeUp/media/menubar_mainmenu_over.dds",
	relatedItemsBtn = "/BeamMeUp/media/help_tabicon_overview.dds",
	relatedItemsBtnOver = "/BeamMeUp/media/help_tabicon_overview_over.dds",
	currentZoneBtn = "/BeamMeUp/media/menubar_map.dds",
	currentZoneBtnOver = "/BeamMeUp/media/menubar_map_over.dds",
	delvesBtn = "/BeamMeUp/media/poi_delve_complete.dds",
	delvesBtnOver = "/BeamMeUp/media/poi_delve_complete_over.dds",
	publicDungeonBtn = "/BeamMeUp/media/poi_dungeon_complete.dds",
	publicDungeonBtnOver = "/BeamMeUp/media/poi_dungeon_complete_over.dds",
	houseBtn = "/BeamMeUp/media/poi_group_house_owned.dds",
	houseBtnOver = "/BeamMeUp/media/poi_group_house_owned_over.dds",
	groupDungeonBtn = "/BeamMeUp/media/poi_groupinstance_complete.dds",
	groupDungeonBtnOver = "/BeamMeUp/media/poi_groupinstance_complete_over.dds",
	raidDungeonBtn = "/BeamMeUp/media/poi_raiddungeon_complete.dds",
	raidDungeonBtnOver = "/BeamMeUp/media/poi_raiddungeon_complete_over.dds",
	groupZonesBtn = "/BeamMeUp/media/poi_groupdelve_complete.dds",
	groupZonesBtnOver = "/BeamMeUp/media/poi_groupdelve_complete_over.dds",
	groupLeaderBtn = "/BeamMeUp/media/lfg_leader_icon.dds",
	groupLeaderBtnOver = "/BeamMeUp/media/lfg_leader_icon_over.dds",
	zoneNameBtnOver = "/BeamMeUp/media/text_over.dds",
	numberPlayersBtnOver = "/BeamMeUp/media/text_over2.dds",
	guildBtn = "/BeamMeUp/media/menubar_guilds.dds",
	guildBtnOver = "/BeamMeUp/media/menubar_guilds_over.dds",
	guildHouseBtn = "/BeamMeUp/media/guild_hall_temple.dds",
	guildHouseBtnOver = "/BeamMeUp/media/guild_hall_temple_mouseover.dds",
	ptfHouseBtn = "/BeamMeUp/media/ptf_house.dds",
	ptfHouseBtnOver = "/BeamMeUp/media/ptf_house_mouseover.dds",
	soloArenaBtn = "/BeamMeUp/media/poi_solotrial.dds",
	soloArenaBtnOver = "/BeamMeUp/media/poi_solotrial_over.dds",
	dungeonDifficultyNormal = "|t32:32:esoui/art/lfg/lfg_normaldungeon_up.dds|t",
	dungeonDifficultyVeteran = "|t32:32:esoui/art/lfg/lfg_veterandungeon_up.dds|t",
	}
	
-- Special textures for event days
local ld = os.date("*t")
if ld.month == 2 and ld.day >= 11 and ld.day <= 14 then
	-- Valentine's Day (val)
	Teleporter.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_val.dds"
	Teleporter.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_val.dds"
elseif (ld.month == 3 and ld.day >= 20) or (ld.month == 4 and ld.day <= 25) then
	-- Ester (egg)
	Teleporter.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_egg.dds"
	Teleporter.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_egg.dds"
elseif ld.month == 10 and ld.day >= 27 then
	-- Halloween (hw)
	Teleporter.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_hw.dds"
	Teleporter.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_hw.dds"
elseif ld.month == 12 and ld.day >= 17 and ld.day <= 26 then
	-- Christmas (xmas)
	Teleporter.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_xmas.dds"
	Teleporter.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_xmas.dds"
elseif (ld.month == 12 and ld.day >= 29) or (ld.month == 1 and ld.day == 1) or (ld.month == 7 and ld.day == 4 and GetWorldName() == "NA Megaserver") then
	-- New year (nye) + Independence Day (NA only)
	Teleporter.textures.wayshrineBtn2 = "/BeamMeUp/media/poi_wayshrine_complete_nye.dds"
	Teleporter.textures.wayshrineBtnOver2 = "/BeamMeUp/media/poi_wayshrine_complete_over_nye.dds"
end

-- constant values for the source
TELEPORTER_SOURCE_INDEX_GROUP = 1
TELEPORTER_SOURCE_INDEX_FRIEND = 2
TELEPORTER_SOURCE_INDEX_GUILD1 = 3
TELEPORTER_SOURCE_INDEX_GUILD2 = 4
TELEPORTER_SOURCE_INDEX_GUILD3 = 5
TELEPORTER_SOURCE_INDEX_GUILD4 = 6
TELEPORTER_SOURCE_INDEX_GUILD5 = 7

-- flag and cache to check if quest data in journal changed
Teleporter.questDataCache = {}
Teleporter.questDataChanged = true
		
-- second language dropdown choices/values
Teleporter.dropdownSecLangChoices = {"DISABLED", "en", "de", "fr", "ru", "jp", "pl"}
Teleporter.dropdownSecLangValues = {1, 2, 3, 4, 5, 6, 7}

-- sortings dropdown choices/values
Teleporter.dropdownSortChoices = {"zone name", "zone category > zone name", "most used zone > zone name", "most used zone > zone category > zone name", "number of players > zone name", "undiscovered wayshrines > zone category > zone name", "undiscovered skyshards > zone category > zone name"}
Teleporter.dropdownSortValues = {1, 2, 3, 4, 5, 6, 7}

-- prioritization of the sources
Teleporter.dropdownPrioSourceChoices = {"Friends"}
Teleporter.dropdownPrioSourceValues = {TELEPORTER_SOURCE_INDEX_FRIEND}
for i = 1, GetNumGuilds() do
	table.insert(Teleporter.dropdownPrioSourceChoices, GetGuildName(GetGuildId(i)))
	table.insert(Teleporter.dropdownPrioSourceValues, _G["TELEPORTER_SOURCE_INDEX_GUILD" .. tostring(i)])
end

-- flag to toggle debug mode
Teleporter.debugMode = 0

-- game language of the client
Teleporter.lang = GetCVar("language.2")

-- flag to save the current display state (by this the UI display again after opening menus)
Teleporter.displayComeback = false
	
-- flag to block multiple addition of gold
Teleporter.blockGold = false

-- State to show correct persistent MouseOver and for auto refresh
Teleporter.state = 0

-- current SourceIndex 
Teleporter.stateSourceIndex = 0

-- current ZoneID
Teleporter.stateZoneId = 0

-- flag to block multiple auto refresh countdowns
Teleporter.blockCountdown = false

-- flag to check if an error occurred while porting (if an error occurred it contains the error code)
Teleporter.flagSocialErrorWhilePorting = 0

-- flag if the feature "WayshrineAutoUnlocking" is working at the moment
Teleporter.autoUnlockStarted = false

-- flag if the mouse is currently on the "WayshrineAutoUnlocking" Button
Teleporter.autoUnlockButtonOver = false

-- flag to block multiple warning dialogs (incompatibility with No Thank You)
Teleporter.blockDialogNTY = false


mTeleSavedVars = {}


-- !!!!!!!!!  When new zones are added ingame, you have to add the specific zoneIDs here. See the links below for all IDs and names provided from wiki-esoui.
-- !!!!!!!!!  You may have to add new IDs in more then one lists below (depending on zone type). Just read and check all following lists and decide where the new zone ID needs to be added.

----------------------------------------- Blacklists -- zoneId -> http://wiki.esoui.com/Zones
Teleporter.blacklist = {}
Teleporter.blacklistForSlashPorting = {}

-- categories of blacklists:

-- different unaccessable zones (Thieves Den, Dark Brotherhood Sanctuary)
Teleporter.blacklistOthers = {821, 826}

-- all Outlaws Refuges
Teleporter.blacklistRefuges = {746, 747, 748, 479, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 780, 837, 971, 982, 1028, 1088, 1178, 1252}


-- just Cyrodiil
Teleporter.blacklistCyro = {181}

-- imperial city and imperial underground and sewers
Teleporter.blacklistImpCity = {584, 551, 643}

-- Battlegrounds -- order -> http://en.uesp.net/wiki/Online:Battlegrounds
Teleporter.blacklistBattlegrounds = {509, 511, 510, 508, 513, 512, 514, 517, 518}


-- 4 men Group Dungeons -- order -> http://en.uesp.net/wiki/Online:Veteran_Dungeons
Teleporter.blacklistGroupDungeons = {380, 935, 126, 931, 176, 681, 1055, 131, 1052, 31, 22, 38, 1009, 144, 936, 130, 932, 1010, 146, 933, 63, 930, 449, 64, 148, 848, 843, 283, 934, 11, 973, 974, 688, 678, 1080, 1081, 1122, 1123, 1152, 1153, 1201, 1197, 1228, 1229}

-- 12 men Raids (Trials) -- order -> http://en.uesp.net/wiki/Online:Trials
Teleporter.blacklistRaids = {1000, 638, 636, 639, 725, 1051, 975, 1121, 1196, 1263}

-- Solo Arenas -- https://en.uesp.net/wiki/Online:Arenas (Maelstrom Arena, Vateshran Hollows)
Teleporter.blacklistSoloArenas = {677, 1227}

-- Group Arenas -- https://en.uesp.net/wiki/Online:Arenas (Dragonstar, BlackRose Prison)
Teleporter.blacklistGroupArenas = {635, 1082}

-- other zones only for groups (the specific player has to be in the same group) (Group Delves/Dungeons in Craglorn)
Teleporter.blacklistGroupZones = {890, 893, 895, 897, 899, 904, 906, 908, 907, 913, 909, 914, 915, 916}

-- Houses
Teleporter.blacklistHouses = {940, 942, 941, 939, 938, 937, 859, 858, 878, 868, 869, 873, 860, 861, 877, 852, 853, 881, 867, 866, 874, 863, 862, 876, 871, 870, 872, 864, 865, 875, 855, 854, 880, 856, 857, 879, 944, 943, 945, 882, 883, 994, 995, 997, 996, 1005, 1008, 1007, 1006, 1042, 1043, 1044, 1045, 1059, 1060, 1061, 1063, 1108, 1109, 1064, 1125, 1126, 1128, 1129, 1130, 1154, 1155, 1192, 1193, 1199, 1200, 1218, 1219, 1220, 1233, 1234, 1264, 1265, 1270, 1271, 1275, 1276, 1277}

-----------------------------------------

----------------------------------------- Whitelists

-- special Whitelist just for group members: Group Arenas, Group Dungeons in Craglorn, 4 men Group Dungeons, 12 men Group Dungeons
Teleporter.whitelistGroupMembers = {unpack(Teleporter.blacklistGroupArenas),
									unpack(Teleporter.blacklistGroupZones),
									unpack(Teleporter.blacklistGroupDungeons),
									unpack(Teleporter.blacklistRaids)
									}
									

-- List of all Overland-Zones incl. their delves and public dungeons
-- http://en.uesp.net/wiki/Online:Delves   http://en.uesp.net/wiki/Online:Public_Dungeons
Teleporter.overlandDelvesPublicDungeons = {
			-- Greenshade
			[108] = {
					delves = {575, 576, 577, 578, 579, 580},
					publicDungeons = {137},
					},
			-- Auridon
			[381] = {
					delves = {396, 397, 398, 399, 400, 401},
					publicDungeons = {486},
					},
			-- Malabal Tor
			[58] = {
					delves = {468, 469, 470, 471, 472, 473},
					publicDungeons = {138},
					},
			-- Grahtwood
			[383] = {
					delves = {444, 447, 442, 475, 477, 478},
					publicDungeons = {124},
					},
			-- Reaper's March
			[382] = {
					delves = {462, 463, 464, 465, 466, 467},
					publicDungeons = {487},
					},
			-- Alik'r Desert
			[104] = {
					delves = {327, 328, 329, 330, 331, 332},
					publicDungeons = {308},
					},
			-- Stormhaven
			[19] = {
					delves = {315, 316, 317, 318, 319, 320},
					publicDungeons = {142},
					},
			-- Rivenspire
			[20] = {
					delves = {321, 322, 323, 324, 325, 326},
					publicDungeons = {162},
					},
			-- Bangkorai
			[92] = {
					delves = {333, 334, 335, 336, 337, 338},
					publicDungeons = {169},
					},
			-- Glenumbra
			[3] = {
					delves = {309, 310, 311, 312, 313, 314},
					publicDungeons = {284},
					},
			-- Shadowfen
			[117] = {
					delves = {270, 271, 272, 273, 274, 275},
					publicDungeons = {134},
					},
			-- The Rift
			[103] = {
					delves = {413, 485, 484, 481, 482, 480},
					publicDungeons = {341},
					},
			-- Stonefalls
			[41] = {
					delves = {296, 290, 287, 288, 291, 289},
					publicDungeons = {216},
					},
			-- Eastmarch
			[101] = {
					delves = {359, 360, 361, 362, 363, 364},
					publicDungeons = {339},
					},
			-- Deshaan
			[57] = {
					delves = {405, 406, 407, 408, 409, 410},
					publicDungeons = {306},
					},
			-- Coldharbour
			[347] = {
					delves = {417, 418, 419, 420, 421, 422},
					publicDungeons = {557},
					},
			-- Craglorn
			[888] = {
					delves = {889, 891, 892, 894, 896, 898, 900, 901, 902, 903, 905, 910, 890, 893, 895, 897, 899, 904, 906, 908, 907, 913, 909, 914, 915, 916},
					publicDungeons = {},
					},
			-- Wrothgar
			[684] = {
					delves = {694, 693, 689, 691, 692, 697},
					publicDungeons = {705, 706},
					},
			-- Hew's Bane
			[816] = {
					delves = {817, 676},
					publicDungeons = {},
					},
			-- Gold Coast
			[823] = {
					delves = {825, 824},
					publicDungeons = {},
					},
			-- Vvardenfell
			[849] = {
					delves = {961, 921, 922, 923, 924, 925},
					publicDungeons = {919, 918},
					},
			-- The Clockwork City
			[980] = {
					delves = {985, 986},
					publicDungeons = {},
					},
			-- The Clockwork City: The Brass Fortress
			[981] = {
					delves = {985, 986},
					publicDungeons = {},
					},
			-- Summerset (+ "Traitor's Vault")
			[1011] = {
					delves = {1016, 1017, 1015, 1018, 1014, 1019},
					publicDungeons = {1020, 1021},
					},
			-- Artaeum
			[1027] = {
					delves = {1016},
					publicDungeons = {},
					},
			-- Bal Foyen
			[281] = {
					delves = {},
					publicDungeons = {},
					},
			-- Stros M'Kai
			[534] = {
					delves = {},
					publicDungeons = {},
					},
			-- Betnikh
			[535] = {
					delves = {},
					publicDungeons = {},
					},
			-- Khenarthi's Roost
			[537] = {
					delves = {},
					publicDungeons = {},
					},
			-- Bleakrock Isle
			[280] = {
					delves = {},
					publicDungeons = {},
					},
			-- Murkmire
			[726] = {
					delves = {1073, 1066},
					publicDungeons = {},
					},
			-- Northern Elsweyr
			[1086] = {
					delves = {1091, 1092, 1094, 1095, 1096, 1119},
					publicDungeons = {1089, 1090},
					},
			-- Southern Elsweyr
			[1133] = {
					delves = {1134, 1135},
					publicDungeons = {},
					},
			-- Western Skyrim
			[1160] = {
					delves = {1166, 1167, 1168, 1170},
					publicDungeons = {1186},
					},
			-- Blackreach: Greymoor Caverns
			[1161] = {
					delves = {1165, 1169},
					publicDungeons = {1187},
					},
			-- Reach
			[1207] = {
					delves = {1209, 1210},
					publicDungeons = {},
					},
			-- Blackreach: Arkthzand Caverns
			[1208] = {
					delves = {1209},
					publicDungeons = {},
					},
			-- Blackwood
			[1261] = {
					delves = {1253, 1254, 1255, 1256, 1257, 1258},
					publicDungeons = {1259, 1260},
					},
			}
			

-- maps nodeIndicies with specific/selected zoneIds
Teleporter.nodeIndexMap = {
			-- SOLO ARENAS
			[677] = {250, "MSA / MA"},
			[1227] = {457, "VH / Vateshran"},
			-- GROUP ARENAS
			[635] = {270, "DSA"},
			[1082] = {378, "BRP"},
			-- TRIALS
			[1000] = {346, "AS"},
			[638] = {231, "AA"},
			[636] = {230, "HRC / Hel Ra"},
			[639] = {232, "SO"},
			[725] = {258, "MoL"},
			[1051] = {364, "CR"},
			[975] = {331, "HoF"},
			[1121] = {399, "SS"},
			[1196] = {434, "KA"},
			[1263] = {468, "RG"},
			-- GROUP DUNGEONS
			[38] = {186, "BHH / Blackheart"},
			[380] = {194, "BC1 / Banished 1"},
			[935] = {262, "BC2 / Banished 2"},
			[126] = {191, "EH1 / Elden1"},
			[931] = {265, "EH2 / Elden2"},			
			[176] = {197, "CoA 1"},
			[681] = {268, "CoA 2"},
			[1055] = {370, "MoS"},
			[131] = {188, "TI / Tempest"},
			[1052] = {371, "MHK"},
			[31] = {185, "SW / Selene"},
			[22] = {196, "VF / Volenfell"},
			[1009] = {341, "FL"},
			[144] = {193, "SC1 / Spindle 1"},
			[936] = {267, "SC2 / Spindle 2"},
			[130] = {190, "CoH1 / Crypts 1"},
			[932] = {269, "CoH2 / Crypts 2"},
			[1010] = {363, "SCP"},
			[146] = {189, "WRS1 / Wayrest 1"},
			[933] = {263, "WRS2 / Wayrest 2"},
			[63] = {198, "DSC 1 / Darkshade 1"},
			[930] = {264, "DSC 2 / Darkshade 2"},
			[449] = {195, "DFK / DK / Direfrost"},
			[64] = {187, "Crucible"},
			[148] = {192, "AC / Arx"},
			[848] = {261, "CoS"},
			[843] = {260, "RoM / Mazza"},
			[283] = {98, "FG1 / Fungal 1"},
			[934] = {266, "FG2 / Fungal 2"},
			[11] = {184, "VoM / Vaults"},
			[973] = {326, "BRF / BF"},
			[974] = {332, "FH"},
			[688] = {247, "WGT"},
			[678] = {236, "ICP / Prison"},
			[1080] = {389, "FV / Frost"},
			[1081] = {390, "DoM"},
			[1122] = {391, "MGF / MF"},
			[1123] = {398, "LoM"},
			[1152] = {424, "IR / Ice"},
			[1153] = {425, "UG"},
			[1201] = {436, "CT"},
			[1197] = {435, "SG"},
			[1228] = {437, "BDV"},
			[1229] = {454, "CD / Cauldron"},
}


-----------------------------------------

----------------------------------------- Tresure/Survey Maps

Teleporter.tresureAndSurveyMaps = {
			--Cyrodiil
			[181] = {43703, 43704, 43705, 43706, 43707, 43708, 43709, 43710, 43711, 43712, 43713, 43714, 43715, 43716, 43717, 43718, 43719, 43720},
			-- Greenshade
			[108] = {43637, 43638, 43639, 43640, 43641, 43642, 44938, 57757, 57774, 57788, 57802, 57819, 139427},
			-- Auridon
			[381] = {153640, 43625, 43626, 43627, 43628, 43629, 43630, 44927, 57744, 57733, 57741, 57687, 57738, 139422},
			-- Malabal Tor
			[58] = {153644, 43643, 43644, 43645, 43646, 43647, 43648, 44940, 57777, 57760, 57791, 57805, 57822, 139430},
			-- Grahtwood
			[383] = {43631, 43632, 43633, 43634, 43635, 43636, 44937, 57747, 57750, 57754, 57771, 57816, 139425},
			-- Reaper's March
			[382] = {153645, 43649, 43650, 43651, 43652, 43653, 43654, 44941, 57808, 57763, 57780, 57793, 57825, 139432},
			-- Alik'r Desert
			[104] = {153639, 43613, 43614, 43615, 43616, 43617, 43618, 44926, 57762, 57779, 57792, 57806, 57824, 139431},
			-- Stormhaven
			[19] = {43601, 43602, 43603, 43604, 43605, 43606, 44945, 57749, 57752, 57756, 57773, 57818, 139408},
			-- Rivenspire
			[20] = {153646, 43607, 43608, 43609, 43610, 43611, 43612, 44942, 57759, 57776, 57790, 57804, 57821, 139429},
			-- Bangkorai
			[92] = {153641, 43619, 43620, 43621, 43622, 43623, 43624, 44929, 57810, 57764, 57781, 57795, 57827, 139434},
			-- Glenumbra
			[3] = {153642, 43507, 43525, 43527, 43600, 43509, 43526, 44936, 57734, 57739, 57742, 57745, 57736, 139423},
			-- Shadowfen
			[117] = {153647, 43667, 43668, 43669, 43670, 43671, 43672, 44943, 57758, 57775, 57789, 57803, 57820, 139428},
			-- The Rift
			[103] = {43679, 43680, 43681, 43682, 43683, 43684, 44947, 57765, 57782, 57794, 57809, 57826, 139433},
			-- Stonefalls
			[41] = {153648, 43655, 43656, 43657, 43658, 43659, 43660, 44944, 57737, 57740, 57743, 57746, 57735, 139424},
			-- Eastmarch
			[101] = {153643, 43673, 43674, 43675, 43676, 43677, 43678, 44935, 57761, 57778, 57801, 57807, 57823, 139440},
			-- Deshaan
			[57] = {43661, 43662, 43663, 43664, 43665, 43666, 44934, 57748, 57751, 57755, 57772, 57817, 139426},
			-- Coldharbour
			[347] = {43685, 43686, 43687, 43688, 43689, 43690, 44932, 57796, 57797, 57766, 57767, 57811, 57812, 57783, 57784, 57828, 57829, 139435, 139436},
			-- Craglorn
			[888] = {43721, 43722, 43723, 43724, 43725, 43726, 57798, 57799, 57800, 57768, 57769, 57770, 57830, 57831, 57832, 57785, 57786, 57787, 57813, 57814, 57815, 139437, 139439, 139438},
			-- Wrothgar
			[684] = {43727, 43728, 43729, 43730, 43731, 43732, 71065, 71066, 71067, 71068, 71069, 71070, 71080, 71081, 71082, 71083, 71084, 71085, 71086, 71087, 71088, 139441, 139442, 139443},
			-- Hew's Bane
			[816] = {43733, 43734},
			-- Gold Coast
			[823] = {43735, 43736},
			-- Vvardenfell
			[849] = {126122, 126111, 126110, 126113, 126112, 43743, 43744, 43745, 43737, 43738, 43739, 43740, 43741, 43742, 12612, 12611, 139444},
			-- The Clockwork City
			[980] = {43746, 43747},
			-- Summerset
			[1011] = {139008, 139009, 139007, 43748, 43750, 43751, 43752, 43753, 43749},
			-- Bal Foyen
			[281] = {43701, 43702, 44928},
			-- Stros M'Kai
			[534] = {43691, 43692, 44946},
			-- Betnikh
			[535] = {43693, 43694, 44930},
			-- Khenarthi's Roost
			[537] = {43695, 43696, 43697, 43698, 44939, 45010},
			-- Bleakrock Isle
			[280] = {43699, 43700, 44931},
			-- Murkmire
			[726] = {145510, 145512},
			-- Northern Elsweyr
			[1086] = {147922, 147923, 147924, 151613, 151614, 151615, 151616, 151617, 151618, 151602, 151599, 151601, 151598, 151600, 151603},
			-- Southern Elsweyr
			[1133] = {156716, 156715},
			-- Western Skyrim
			[1160] = {166035, 166040, 166041, 166042, 166043, 166459, 166460, 166461, 166462, 166464, 166465},
			-- Blackreach: Greymoor Caverns
			[1161] = {166036, 166037, 166038, 166039},
			-- The Reach
			[1207] = {171474},
			-- Blackreach: Arkthzand Cavern
			[1208] = {171475},
			-- Blackwood
			[1261] = {175544, 175545, 175546, 175547, 175548, 175549, 175550, 175551, 175552, 178464, 178465, 178466, 178467, 178468, 178469},
			}

-----------------------------------------
function Teleporter.joinBlacklist(list)
	-- join the lists to global blacklist (merge to HashMap instead to a list)
   for index, value in ipairs(list) do
      Teleporter.blacklist[value] = true
   end 
end


function Teleporter.getAllDelves()
	local newList = {}
	-- gather all delves from the global list
	for parentZoneId, tableObject in pairs(Teleporter.overlandDelvesPublicDungeons) do
		for index, zoneId in ipairs(tableObject.delves) do
			table.insert(newList, zoneId)
		end
	end
	return newList
end

function Teleporter.getAllPublicDungeons()
	local newList = {}
	-- gather all public dungeons from the global list
	for parentZoneId, tableObject in pairs(Teleporter.overlandDelvesPublicDungeons) do
		for index, zoneId in ipairs(tableObject.publicDungeons) do
			table.insert(newList, zoneId)
		end
	end
	return newList
end
----------------------------------------- Categories
--[[
Teleporter.CategoryMap = {}

-- Delves / Solo Dungeons from all maps
Teleporter.categoryDelves = Teleporter.getAllDelves()
							
-- Public Dungeons from all maps
Teleporter.categoryPublicDungeons = Teleporter.getAllPublicDungeons()

-- Houses (same as the Blacklist for Houses)
Teleporter.categoryHouses = Teleporter.blacklistHouses

-- 4 men Group Dungeons
Teleporter.categoryGroupDungeons = Teleporter.blacklistGroupDungeons

-- 12 men Raid (Trials)
Teleporter.categoryRaids = Teleporter.blacklistRaids

-- zones only for groups (Group Dungeons in Craglorn)
Teleporter.categoryGroupZones = Teleporter.blacklistGroupZones

-- Solo Arenas
Teleporter.categorySoloArenas = Teleporter.blacklistSoloArenas

-- Group Arenas
Teleporter.categoryGroupArenas = Teleporter.blacklistGroupArenas
--]]
-----------------------------------------

----------------------------------------- Sorting/Grouping
Teleporter.sortingByCategory = {[9] = 1, [2] = 2, [1] = 3, [0] = 4, [5] = 5, [4] = 6, [7] = 7, [6] = 8, [3] = 9, [8] = 10}
-- Overland, Public Dungeons, Delves, without Category, 12 men Dungeons, 4 men Dungeons, Group Arenas, Group Zones (Craglorn), Houses, Solo Arenas


-----------------------------------------

Teleporter.ParentMap = {}

