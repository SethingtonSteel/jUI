-----------------------------------------
-- LOCALIZED GLOBAL VARIABLES
-----------------------------------------

local ZGV = _G.ZGV
local Data = {}
local Travel

-----------------------------------------
-- SAVED REFERENCES
-----------------------------------------

Travel = ZGV.Travel
Travel.Data = Data

-----------------------------------------
-- MAP DATA
-----------------------------------------

--[[
	\s*(\[.*\]) = ([0-9]*),\n  	->	\t\1 = \2,\n
	\t(\[.*\]) = ([0-9]*)		->	\t\2##\1 = \2
	\t[0-9]*##			->	\t
--]]


Data.MapIdsByName = {

	-- Aldmeri Dominion
	-- Khenarthi's Roost
	["Khenarthi's Roost"]                   =   1,
	["Temple of the Mourning Spring"]       =   2,
	["Hazak's Lair"]                        =   3,
	["The Mangroves"]                       =   4,
	["Mistral"]                             =   5,
	["Cat's Eye Quay"]                      =   6,
	
	-- Auridon
	["Vulkhel Guard"]                       =   7,
	["Vulkhel Guard Outlaws Refuge"]        =   8,
	["Auridon"]                             =   9,
	["Del's Claim"]                         =  10,
	["Ondil"]                               =  11,
	["Phaer Catacombs"]                     =  12,
	["Inner Tanzelwil"]                     =  13,
	["Tower of the Vale - Temple"]          =  14,
	["Tower of the Vale - Rage"]            =  15,
	["Tower of the Vale - Bliss"]           =  16,
	["Tower of the Vale - Bliss Top"]       =  17,
	["Tower of the Vale - Despair"]         =  18,
	["Entila's Folly"]                      =  19,
	["Smugglerstunnel"]                     =  20,
	["Skywatch"]                            =  21,
	["Ezduiin Undercroft"]                  =  22,
	["Wansalen"]                            =  23,
	["Quendeluun South Ruins"]              =  24,
	["Abandoned Mine"]                      =  25,
	["Bewan"]                               =  26,
	["Saltspray Cave"]                      =  27,
	["Torinaan Shrine"]                     =  28,
	["Mehrunes' Spite"]                     =  29,
	["The Vault of Exile"]                  =  30,
	["Firsthold"]                           =  31,
	["The Refuge of Dread"]                 =  32,
		
	-- Grahtwood
	["Haven"]                               =  33,
	["Haven Sewers"]                        =  34,
	["Grahtwood"]                           =  35,
	["Sacred Leap Grotto"]                  =  36,
	["The Scuttle Pit"]                     =  37,
	["Brackenleaf"]                         =  38,
	["Elden Root"]                          =  39,
	["Elden Root Mages Guild"]              =  40,
	["Elden Root Throne Room"]              =  41,
	["Elden Root Fighters Guild"]           =  42,
	["Elden Root Outlaws Refuge"]           =  43,
	["Cave of Broken Sails"]                =  44,
	["Gray Mire"]                           =  45,
	["Bone Orchard"]                        =  46,
	["Cathedral of the Golden Path"]        =  47,
	["Ne Salas"]                            =  48,
	["Mobar Mine"]                          =  59,
	["The Middens"]                         =  50,
	["Vinedeath Cave"]                      =  51,
	["Ossuary of Telacar"]                  =  52,
	["Laeloria Ruins"]                      =  53,
	["Karthdar"]                            =  54,
	["Cormount Prison"]                     =  55,
	["Reliquary Ruins"]                     =  56,
	["Faltonia's Mine"]                     =  57,
	["Barkbite Cave"]                       =  58,
	["Redfur Trading Post"]                 =  59,
	["Tomb of Anahbi"]                      =  60,
	["Burroot Kwama Mine"]                  =  61,
	["Nairume's Prison"]                    =  62,
	["The Orrery"]                          =  63,
		
	-- Greenshade
	["Marbruk"]                             =  64,
	["Marbruk Outlaws Refuge"]              =  65,
	["Greenshade"]                          =  66,
	["Gurzag's Mine"]                       =  67,
	["Camp Gushnukbur"]                     =  68,
	["Shrouded Hollow"]                     =  69,
	["Fading Tree"]                         =  70,
	["Shrouded Hollow"]                     =  71,
	["Carac Dena"]                          =  72,
	["Silatar"]                             =  73,
	["Hollow Den"]                          =  74,
	["Shademist Enclave"]                   =  75,
	["Naril Nagaia"]                        =  76,
	["Woodhearth"]                          =  77,
	["Imperial Underground"]                =  78,
	["Ilmyris"]                             =  79,
	["Serpent's Grotto"]                    =  80,
	["The Underroot"]                       =  81,
	["Abecean Sea"]                         =  82,
	["Old Merchant Caves"]                  =  83,
	["Harridan's Lair"]                     =  84,
	["Nereid Temple Cave"]                  =  85,
	["Falinesti Cave"]                      =  86,
	["Hectahame Grotto"]                    =  87,
	["Valenheart"]                          =  88,
	["Isles of Torment"]                    =  89,
	["Barrow Trench"]                       =  90,
			
	-- Malbal Tor
	["Velyn Harbor"]                        =  91,
	["Malabal Tor Outlaws Refuge"]          =  92,
	["Malabal Tor"]                         =  93,
	["Stormwarden Undercroft"]              =  94,
	["Dead Man's Drop"]                     =  95,
	["Tomb of Apostates"]                   =  96,
	["Hoarvor Pit"]                         =  97,
	["Vulkwasten"]                          =  98,
	["Ogrim's Yawn"]                        =  99,
	["Abamath Ruins"]                       = 100,
	["Shrine of Mauloch"]                   = 101,
	["Shael Ruins"]                         = 102,
	["Roots of Silvenar"]                   = 103,
	["Ouze"]                                = 104,
	["Baandari Trading Post"]               = 105,
	["Roots of Treehenge"]                  = 106,
	["Black Vine Ruins"]                    = 107,
	["The Hunting Grounds"]                 = 108,
	["Silvernar Throne Room"]               = 109,
			
	-- Reapers March
	["Reaper's March"]                      = 110,
	["Vinedusk Village Corridor"]           = 111,
	["Khaj Rawlith"]                        = 112,
	["Senalana"]                            = 113,
	["Arenthia"]                            = 114,
	["Greenhill Catacombs"]                 = 115,
	["Thibaut's Cairn"]                     = 116,
	["Halls of Ichor"]                      = 117,
	["Rawl'kha"]                            = 118,
	["Rawl'kha Temple"]                     = 119,
	["Rawl'kha Outlaws Refuge"]             = 120,
	["Weeping Wind Cave"]                   = 121,
	["Moonmont Temple"]                     = 122,
	["Do'Krin Temple"]                      = 123,
	["Claw's Strike"]                       = 124,
	["S'ren-ja Bandit Cave"]                = 125,
	["S'ren-ja Well"]                       = 126,
	["S'ren-ja Cave"]                       = 127,
	["Jode's Light"]                        = 128,
	["Kuna's Delve"]                        = 129,
	["Heart of the Wyrd Tree"]              = 130,
	["Fort Sphinxmoth"]                     = 131,
	["Fardir's Folly"]                      = 132,
	["Dune"]                                = 133,
	["Temple of the Dance"]                 = 134,
	["The Demi-Plane of Jode"]              = 135,
	["The Wild Hunt"]                       = 136,
	["Urcelmo's Betrayal"]                  = 137,
	["Den of Lorkhaj"]                      = 138,
	
	-- Daggerfall Covenant
	-- Stros M'Kai
	["Port Hunding"]                        = 139,
	["The Grave"]                           = 140,
	["Stros M'Kai"]                         = 141,
	["Goblin Mines"]                        = 142,
	["Bthzark"]                             = 143,
		
	-- Betnikh
	["Stonetooth Fortress"]                 = 144,
	["Betnikh"]                             = 145,
	["Bloodthorn Lair"]                     = 146,
	["Ancient Carzog's Demise"]             = 147,
	["Moriseli"]                            = 148,
	["Carzog's Demise"]                     = 149,
		
	-- Glenumbra
	["Daggerfall"]                          = 150,
	["Daggerfall Outlaws Refuge"]           = 151,
	["Glenumbra"]                           = 152,
	["Ilessan Tower"]                       = 153,
	["East Hut Portal Cave"]                = 154,
	["South Hut Portal Cave"]               = 155,
	["West Hut Portal Cave"]                = 156,
	["North Hut Portal Cave"]               = 157,
	["Silumm"]                              = 158,
	["Enduum"]                              = 159,
	["Dresan Keep"]                         = 160,
	["Aldcroft"]                            = 161,
	["The Mines of Khuras"]                 = 162,
	["Desolation's End"]                    = 163,
	["Ebon Crypt"]                          = 164,
	["Cath Bedraud"]                        = 165,
	["Breagha-Fin"]                         = 166,
	["Cryptwatch Fort"]                     = 167,
	["Crosswych"]                           = 168,
	["Crosswych Mine"]                      = 169,
	
	-- Stormhaven
	["Koeglin Village"]                     = 170,
	["Stormhaven"]                          = 171,
	["Alcaire Castle"]                      = 172,
	["Windridge Cave"]                      = 173,
	["Portdun Watch"]                       = 174,
	["Pariah Catacombs"]                    = 175,
	["Wayrest"]                             = 176,
	["Wayrest Outlaws Refuge"]              = 177,
	["Farangel's Delve"]                    = 178,
	["Bearclaw Mine"]                       = 179,
	["Godrun's Dream"]                      = 180,
	["Norvulk Ruins"]                       = 181,
	["Aphren's Tomb"]                       = 182,
	["Emeric's Dream"]                      = 183,
						
	-- Rivenspire
	["Rivenspire"]                          = 184,
	["Shornhelm"]                           = 185,
	["Shornhelm Outlaws Refuge"]            = 186,
	["Fevered Mews"]                        = 187,
	["Crestshade Mine"]                     = 188,
	["Doomcrag"]                            = 189,
	["Shadowfate Cavern"]                   = 190,
	["Hoarfrost Downs"]                     = 191,
	["Tribulation Crypt"]                   = 192,
	["Lorkrata Ruins"]                      = 193,
	["Edrald Undercroft"]                   = 194,
	["Flyleaf Catacombs"]                   = 195,
	["Northpoint"]                          = 196,
	["Breagha-Fin"]                         = 197,
	["Orc's Finger Ruins"]                  = 198,
	["Hildune's Secret Refuge"]             = 199,
	["Erokii Ruins"]                        = 200,
	["Shrouded Pass"]                       = 201,
				
	-- Alik'r Desert
	["Sentinel"]                            = 202,
	["Sentinel Outlaws Refuge"]             = 203,
	["Alik'r Desert"]                       = 204,
	["Shore Cave"]                          = 205,
	["Impervious Vault"]                    = 206,
	["Santaki"]                             = 207,
	["Salas En"]                            = 208,
	["The Portal Chamber"]                  = 209,
	["Ash'abah Pass"]                       = 210,
	["Yokudan Palace"]                      = 211,
	["Divad's Chagrin Mine"]                = 212,
	["Bergama"]                             = 213,
	["Magistrate's Basement"]               = 214,
	["Aldunz"]                              = 215,
	["The Master's Crypt"]                  = 216,
	["Kulati Mines"]                        = 217,
	["Coldrock Diggings"]                   = 218,
	["Sandblown Mine"]                      = 219,
	["Yldzuun"]                             = 220,
	["Kozanset"]                            = 221,
	["Smuggler King Tunnel"]                = 222,
	["Suturah's Crypt"]                     = 223,
		
	-- Bangkorai
	["Evermore"]                            = 224,
	["Evermore Outlaws Refuge"]             = 225,
	["Bangkorai"]                           = 226,
	["Bisnensel"]                           = 227,
	["Torog's Spite"]                       = 228,
	["Crypt of the Exiles"]                 = 229,
	["Troll's Toothpick"]                   = 230,
	["Nchu Duabthar Threshold"]             = 231,
	["Viridian Watch"]                      = 232,
	["Bangkorai Garrison"]                  = 233,
	["Sunken Road"]                         = 234,
	["Klathzgar"]                           = 235,
	["Rubble Butte"]                        = 236,
	["Nilata Ruins"]                        = 237,
	["Anexiel's Lair"]                      = 238,
	["Hallin's Stand"]                      = 239,
	["Onsi's Breath Mine"]                  = 240,
	["Hall of Heroes"]                      = 241,
	["The Far Shores"]                      = 242,
	
	-- Ebonheart Pact
	-- Bleakrock Isle
	["Bleakrock Village"]                   = 243,
	["Bleakrock Isle"]                      = 244,
	["Skyshroud Barrow"]                    = 245,
	["Hozzin's Folly"]                      = 246,
	["Orkey's Hollow"]                      = 247,
	["Last Rest"]                           = 248,
	
	-- Bal Foyen
	["Bal Foyen"]                           = 249,
	["Dhalmora"]                            = 250,
	["Smuggler Tunnel"]                     = 251,
	
	-- Stonefalls
	["Stonefalls"]                          = 252,
	["Davon's Watch"]                       = 253,
	["House Indoril Crypt"]                 = 254,
	["Davon's Watch Outlaws Refuge"]        = 255,
	["Charred Ridge"]                       = 256,
	["Ash Mountain"]                        = 257,
	["Inner Sea Armature"]                  = 258,
	["Emberflint Mine"]                     = 259,
	["Mephala's Nest"]                      = 260,
	["Fort Arand Dungeons"]                 = 261,
	["Ebonheart"]                           = 262,
	["Coral Heart Chamber"]                 = 263,
	["Softloam Cavern"]                     = 264,
	["Heimlyn Keep Reliquary"]              = 265,
	["Fort Virak Ruin"]                     = 266,
	["Iliath Temple Mines"]                 = 267,
	["Sheogorath's Tongue"]                 = 268,
	["Kragenmoor"]                          = 269,
	["House Dres Crypts"]                   = 270,
	["Hightide Hollow"]                     = 271,
	["Tormented Spire"]                     = 272,
		
	
	-- Deshaan
	["Deshaan"]                             = 273,
	["Quarantine Serk Catacombs"]           = 274,
	["Narsis"]                              = 275,
	["Narsis Ruins"]                        = 276,
	["Lady Llarel's Shelter"]               = 277,
	["Obsidian Gorge"]                      = 278,
	["Apothacarium"]                        = 279,
	["Mzithumz"]                            = 280,
	["Mournhold"]                           = 281,
	["Mournhold Sewers"]                    = 282,
	["Mournhold Outlaws Refuge"]            = 283,
	["The Triple Circle Mine"]              = 284,
	["Tribunal Temple"]                     = 285,
	["Bthanual"]                            = 286,
	["Lower Bthanual"]                      = 287,
	["Deepcrag Den"]                        = 288,
	["Shad Astula Underhalls"]              = 289,
	["Taleon's Crag"]                       = 290,
	["Vale of the Ghost Snake"]             = 291,
	["Tal'Deic Crypts"]                     = 292,
	["The Shrine of St. Veloth"]            = 293,
	["The Corpse Garden"]                   = 294,
	["Knife Ear Grotto"]                    = 295,
	["Eidolon's Hollow"]                    = 296,
	["Reservoir of Souls"]                  = 297,
	
	-- Shadowfen
	["Stormhold"]                           = 298,
	["Silyanorn Ruins"]                     = 299,
	["Stormhold Outlaws Refuge"]            = 300,
	["Shrine of the Black Maw"]             = 301,
	["Odious Chapel"]                       = 302,
	["Mud Tree Mine"]                       = 303,
	["Mudshallow Cave"]                     = 304,
	["Ruins of Ten-Maur-Wolk"]              = 305,
	["Lair of the Skin Stealer"]            = 306,
	["Alten Corimont"]                      = 307,
	["Tsanji's Hideout"]                    = 308,
	["Atanaz Ruins"]                        = 309,
	["Broken Tusk"]                         = 310,
	["Onkobra Kwama Mine"]                  = 311,
	["Sunscale Ruins"]                      = 312,
	["Gandranen Ruins"]                     = 313,
	["Temple of Sul"]                       = 314,
	["White Rose Prison Dungeon"]           = 315,
	["Chid-Moska Ruins"]                    = 316,
	["Loriasel"]                            = 317,
	["Vision of the Hist"]                  = 318,
	
	-- Eastmarch
	["Windhelm"]                            = 319,
	["Windhelm Outlaws Refuge"]             = 320,
	["The Chill Hollow"]                    = 321,
	["Eastmarch"]                           = 322,
	["Cradlecrush Arena"]                   = 323,
	["Icehammer's Vault"]                   = 324,
	["Fort Morvunskar"]                     = 325,
	["Giant's Run"]                         = 326,
	["Fort Amol"]                           = 327,
	["Lost Knife Cave"]                     = 328,
	["The Frigid Grotto"]                   = 329,
	["Bonestrewn Crest"]                    = 330,
	["Wittestadr Crypts"]                   = 331,
	["Mistwatch Crevasse"]                  = 332,
	["Old Sord's Cave"]                     = 333,
	["Stormcrag Crypt"]                     = 334,
	["The Bastard's Tomb"]                  = 335,
	["Mzulft"]                              = 336,
	["Cragwallow"]                          = 337,
	
	-- The Rift
	["Shor's Stone"]                        = 338,
	["Shor's Stone Mine"]                   = 339,
	["The Rift"]                            = 340,
	["Fallowstone Vault"]                   = 341,
	["Northwind Mine"]                      = 342,
	["Vaults of Vernim"]                    = 343,
	["Snapleg Cave"]                        = 344,
	["Nimalten"]                            = 345,
	["Nimalten Barrow"]                     = 346,
	["Shroud Hearth Barrow"]                = 347,
	["Pinepeak Caverns"]                    = 348,
	["Taarengrav Barrow"]                   = 349,
	["Arcwind Point"]                       = 350,
	["Broken Helm Hollow"]                  = 351,
	["Avanchnzel"]                          = 352,
	["Riften"]                              = 353,
	["Riften Outlaws Refuge"]               = 354,
	["Fort Greenwall"]                      = 355,
	["Lost Prospect"]                       = 356,
	["Broken Helm"]                         = 357,
	["Forelhost"]                           = 358,
	["Trolhetta Cave"]                      = 359,
	["Trolhetta Summit"]                    = 360,
	
	-- Coldharbour
	["Coldharbour"]                         = 361,
	["The Hollow City"]                     = 362,
	["Tower of Lies"]                       = 363,
	["Cave of Trophies"]                    = 364,
	["Haj Uxith"]                           = 365,
	["Library of Dusk"]                     = 366,
	["Lightless Oubliette"]                 = 367,
	["Lightless Cell"]                      = 368,
	["Aba-Loria"]                           = 369,
	["Reaver Citadel Pyramid"]              = 370,
	["Holding Cells"]                       = 371,
	["The Cave of Trophies"]                = 372,
	["The Vault of Haman Forgefire"]        = 373,
	["Thane's Lair"]                        = 374,
	["The Black Forge"]                     = 375,
	["The Great Shackle"]                   = 376,
	["The Mooring"]                         = 377,
	["Grunda's Gatehouse"]                  = 378,
	["Mal Sorra's Tomb"]                    = 379,
	["The Manor of Revelry"]                = 380,
	["Cave of Revelry"]                     = 381,
	["The Wailing Maw"]                     = 382,
	["The Lost Fleet"]                      = 383,
	["Reaver Citadel Pyramid"]              = 384,
	["The Endless Stair"]                   = 385,
	
	-- Five Companions
	["The Wailing Prison"]                  = 386,
	["The Harborage"]                       = 387,
	["Vision of the Companions"]            = 388,
	["Foundry of Woe"]                      = 389,
	["The Worm's Retreat"]                  = 390,
	["Castle of Worms"]                     = 391,
	["Halls of Torment"]                    = 392,
	["Valley of Blades"]                    = 393,
	["Ancestral Crypt"]                     = 394,
	["Sancre Tor"]                          = 395,
	["Heart's Grief"]                       = 396,
	["Coldored Rooms"]                      = 397,
	
	-- Fighter's Guild
	["Buraniim"]                            = 398,
	["Dourstone Vault"]                     = 399,
	["Stonefang Cavern"]                    = 400,
	["Mzeneldt"]                            = 401,
	["Abagarlas"]                           = 402,
	["The Earth Forge"]                     = 403,
	["Ragnthar"]                            = 404,
	["Halls of Submission"]                 = 405,

	-- Mages Guild
	["Cheesemonger's Hollow"]               = 406,
	["Shivering Isles"]                     = 407,
	["Vuldngrav"]                           = 408,
	["Asakala"]                             = 409,
	["Circus of Cheerful Slaughter"]        = 410,
	["Chateau of the Ravenous Rodent"]      = 411,
	["Chateau Master Bedroom"]              = 412,
	["Eyevea"]                              = 413,
	
	-- Craglorn
	["Belkarth"]                            = 414,
	["Belkarth Outlaws Refuge"]             = 415,
	["Craglorn"]                            = 416,
	["Buried Sands"]                        = 417,
	["Tombs of the Na-Totambu"]             = 418,
	["Haddock's Market"]                    = 419,
	["Frost Monarch Lair"]                  = 420,
	["Storm Monarch Lair"]                  = 421,
	["Molavar"]                             = 422,
	["Balamath"]                            = 423,
	["Balamath Hall"]                       = 424,
	["Reinhold's Retreat"]                  = 425,
	["Dragonstar"]                          = 426,
	["Fearfangs Cavern"]                    = 427,
	["Sunken Lair"]                         = 428,
	["Serpent's Nest"]                      = 429,
	["Ilthag's Undertow"]                   = 430,
	["Exarch's Stronghold"]                 = 431,
	["The Howling Sepulchers"]              = 432,
	["Loth'Na Caverns"]                     = 433,
	["Skyreach Temple"]                     = 434,
	["Apex Stone Room"]                     = 435,
	["Rkundzelft"]                          = 436,
	["Hircine's Haunt"]                     = 437,
	["Elinhir Sewerworks"]                  = 438,
	["Mtharnaz"]                            = 439,
	["Ruins of Kardala"]                    = 440,
	["Chiselshriek Mine"]                   = 441,
	["Rkhardahrk"]                          = 442,
	["Zalgaz's Den"]                        = 443,
	
	-- Imperial City
	["Western Elsweyr Gate"]                = 444,
	["Eastern Elsweyr Gate"]                = 445,
	["Imperial Sewers Aldmeri Base"]        = 446,
	["Imperial City"]                       = 447,
	["Dragonfire Cathedral"]                = 448,
	["Northern High Rock Gate"]             = 449,
	["Southern High Rock Gate"]             = 450,
	["Cyrodiil"]                            = 451,
	["Imperial Sewers Daggerfall Base"]     = 452,
	["Southern Morrowind Gate"]             = 453,
	["Northern Morrowind Gate"]             = 454,
	["Imperial Sewers Ebonheart Base"]      = 455,
	
	-- Orsinium
	["Wrothgar"]                            = 456,
	["Nikolvara's Kennel"]                  = 457,
	["Orsinium "]                           = 458,
	["Orsinium Outlaws Refuge"]             = 459,
	["Frost Break Fort"]                    = 460,
	["Ice Heart's Lair"]                    = 461,
	["Scarp Keep"]                          = 462,
	["Orsinium Temple"]                     = 463,
	["Temple Rectory"]                      = 464,
	["Graystone Quarry Depths"]             = 465,
	["Honor's Rest Catacombs"]              = 466,
	["Halls of Honor"]                      = 467,
	["Bloody Knoll"]                        = 468,
	["Coldperch Cavern"]                    = 469,
	["Bonerock Cavern"]                     = 470,
	["Morkul"]                              = 471,
	["Morkul Descent "]                     = 472,
	["Morkuldin"]                           = 473,
	["Exile's Barrow"]                      = 474,
	["Zthenganaz"]                          = 475,
	["Fharun Prison"]                       = 476,
	["Fharun Stronghold"]                   = 477,
	["Sorrow"]                              = 478,
	["Argent Mine"]                         = 479,
	["Thukhozod's Sanctum"]                 = 480,
	["Watcher's Hold"]                      = 481,
	["Paragon's Remembrance"]               = 482,
	["Chambers of Loyalty"]                 = 483,
	["Temple Library"]                      = 484,
	["Temple Undertunnels"]                 = 485,
	
	-- Thieves Guild
	["Fulstrom Homestead"]                  = 486,
	["Fulstrom Catacombs"]                  = 487,
	["Abah's Landing"]                      = 488,
	["Safe House"]                          = 489,
	["Maw_of_Lorkaj_Base"]                  = 490,
	["Sulima Mansion"]                      = 491,
	["Hew's bane"]                          = 492,
	["Bahraha's Gloom"]                     = 493,
	["No Shira Citadel"]                    = 494,
	["Vermont Mansion"]                     = 495,
	["al-Danobia Tomb"]                     = 496,
	["Shark's Teeth Grotto"]                = 497,
	["Hubalajad Palace"]                    = 498,

	-- Dark Brotherhood
	["Anvil"]                               = 499,
	["Anvil Outlaws Refuge"]                = 500,
	["Gold Coast"]                          = 501,
	["Jarol's Estate"]                      = 502,
	["Jarol's Estate Wine Cellar"]          = 503,
	["Jarol's Estate Smuggling Tunnels"]    = 504,
	["Hrota Cave"]                          = 505,
	["Garlas Agea"]                         = 506,
	["Dark Brotherhood Sanctuary"]          = 507,
	["Kvatch"]                              = 508,
	["At-Himah Family Estate"]              = 509,
	["Jerall Mountains"]                    = 510,
	["Castle Anvil"]                        = 511,
	["Castle Kvatch"]                       = 512,
	["Enclave of the Hourglass"]            = 513,
	["Blackwood Borderlands"]               = 514,
	["Knightsgrave"]                        = 515,
	["Cathedral of Akatosh"]                = 516,
	
	-- Vvardenfell
	["Vvardenfell"]                         = 517,
	["Andrano Ancestral Tomb"]              = 518,
	["Vivec City"]                          = 519,
	["Vivec City Outlaws Refuge"]           = 520,
	["Palace Recieving Room"]               = 521,
	["Library of Vivec"]                    = 522,
	["Archcanon's Office"]                  = 523,
	["Hall of Justice"]                     = 524,
	["Sadrith Mora"]                        = 525,
	["Barilzar's Tower"]                    = 526,
	["Zaintiraris"]                         = 527,
	["Pinsun"]                              = 528,
	["Pulk"]                                = 529,
	["Zalkin-Sul Egg Mine"]                 = 530,
	["Mzanchend"]                           = 531,
	["Vassamsi Mine"]                       = 532,
	["Tusenend"]                            = 533,
	["Dreudurai Glass Mine"]                = 534,
	["Bal Ur"]                              = 535,
	["Zainsipilu"]                          = 536,
	["Balmora"]                             = 537,
	["Firemoth Island"]                     = 538,
	["Shulk Ore Mine"]                      = 539,
	["Vassir-Danat Mine"]                   = 540,
	["Ashurnibibi"]                         = 541,
	["Mallapi Cave"]                        = 542,
	["Kudanat Mine"]                        = 543,
	["Redoran Garrison"]                    = 544,
	["Ramimilk"]                            = 545,
	["Ashimanu Cave"]                       = 546,
	["Hleran Ancestral Tomb"]               = 547,
	["Gnisis Egg Mine"]                     = 548,
	["Ashalmawia"]                          = 549,
	["Prison of Xykenaz"]                   = 550,
	["Cavern of the Incarnate"]             = 551,
	["Skar"]                                = 552,
	["Galom Daeus"]                         = 553,
	["Nchuleft"]                            = 554,
	["Nchuleft Depths"]                     = 555,
	["Arkngthunch-Sturdumz"]                = 556,
	["Kaushtarari"]                         = 557,
	["Lord Vivec's Chambers"]               = 558,
	["Seht's Vault"]                        = 559,
	["Maintence Junction"]                  = 560,
	["Engineering Junction"]                = 561,
	["The Divinity Atelier"]                = 562,
	["Dockworks"]                           = 563,
	["Engineering Access"]                  = 564,
	["Atelier Courtyard"]                   = 565,
	["Dreloth Ancestral Tomb"]              = 566,
	["Veloth Ancestral Tomb"]               = 567,
	["Matus-Akin Egg Mine"]                 = 568,
	["Inanius Egg Mine"]                    = 569,
	["Khartag Point"]                       = 570,
	["Bal Fell"]                            = 571,
	
	-- Clockwork City
	["Clockwork City Vaults"]               = 572,
	["Clockwork City"]                      = 573,
	["Brass Fortress"]                      = 574,
	["Clockwork Basilica"]                  = 575,
	["Serviflume"]                          = 576,
	["Administration Nexus"]                = 577,
	["Mechanical Fundament"]                = 578,
	["Ventral Terminus"]                    = 579,
	["Incarnatorium"]                       = 580,
	["The Shadow Cleft"]                    = 581,
	["Mnemonic Planisphere"]                = 582,
	["Slag Town Outlaws Refuge"]            = 583,
	["Evergloom"]                           = 584,
	["Cogitum Centralis"]                   = 585,
	["Everwound Wellspring"]                = 586,
	["Halls of Regulation"]                 = 587,
	
   	-- SUMMERSET
	["Summerset"]                           = 588,
	["Alinor"]                              = 589,
	["Lillandril"]                          = 590,
	["Shimmerene"]                          = 591,
	["Sunhold"]                             = 592,
	["Monastery Of Serene Harmony"]         = 593,
	["Shimmerene Waterworks"]               = 594,
	["Tor-Hame-Khard"]                      = 595,
	["Archon's Grove"]                      = 596,
	["Artaeum"]                             = 597,
	["The Dreaming Cave"]                   = 598,
	["Ceporah Tower"]                       = 599,
	["Red Temple Catacombs"]                = 600,
	["Rellenthil Sinkhole"]                 = 601,
	["Cey-Tarn Keep"]                       = 602,
	["The Gorge - Cey-Tarn Keep"]           = 603,
	["The Vaults of Heinarwe"]              = 604,
	["Altar Room"]                          = 605,
	["Wasten Coraldale"]                    = 606,
	["Alinor Royal Palace"]                 = 607,
	["Eldbur Ruins"]                        = 608,
	["Cairnar's Mind Trap"]                 = 609,
	["Miriya's Mind Trap"]                  = 610,
	["Oriandra's Mind Trap"]                = 611,
	["College of Psijics Ruins"]            = 612,
	["Psijic Relic Vaults"]                 = 613,
	["K'Tora's Mindscape"]                  = 614,
	["Direnni Acropolis"]                   = 615,
	["King's Haven Pass"]                   = 616,
	["Coral-Splitter Caves"]                = 617,
	["Ebon Sanctum"]                        = 618,
	["Illumination Academy Stacks"]         = 619,
	["Sea Keep"]                            = 620,
	["College of Sapiarchs Labyrinth"]      = 621,
	["Saltbreeze Cave"]                     = 622,
	["Eton Nir Grotto"]                     = 623,
	["The Spiral Skein"]                    = 624,
	["Traitor's Vault"]                     = 625,
	["Evergloam"]                           = 626,
	["Corgrad Wastes"]                      = 627,
	["Karnwasten"]                          = 628,
	["Cathedral of Webs"]                   = 629,
	["Crystal Tower"]                       = 630,
	["Cloudrest"]                           = 631,
	["Rellenthil"]                          = 632,
	
	-- MURKMIRE
	["Lilmoth"]                             = 634,
	["Murkmire"]                            = 635,
	["Ixtaxh Xanmeer"]                      = 636,
	["Bright-Throat Village"]               = 637,
	["Blight Bog Sump"]                     = 638,
	["Wither-Vault"]                        = 639,
	["Swallowed Grove"]                     = 640,
	["Dead-Water Village"]                  = 641,
	["Tomb of Many Spears"]                 = 642,
	["The Dreaming Nest"]                   = 643,
	["The Mists"]                           = 644,
	["Xul-Thuxis"]                          = 645,
	["Root-Whisper Village"]                = 646,
	["Vakka-Bok Village"]                   = 647,
	["Deep-Root"]                           = 648,
	["Remnant of Argon"]                    = 649,

	-- NORTHERN ELSWEYR
	["Elsweyr"]                             = 650,
	["Rimmen"]                              = 651,
	["Riverhold"]                           = 652,
	["Adobe of Ignominy"]                   = 653,
	["Tomb of the Serpents"]                = 654,
	["Smuggler's Hideout"]                  = 655,
	["The Stitches"]                        = 656,
	["Sleepy Senche Mine"]                  = 657,
	["Cicatrice Caverns"]                   = 658,
	["Meirvale Keep Dungeons"]              = 659,
	["Meirvale Keep Courtyard"]             = 660,
	["Meirvale Keep Palace"]                = 661,
	["Meirvale Keep Dugout"]                = 662,
	["Rimmen Palace Recesses"]              = 663,
	["Desert Wind Caverns"]                 = 664,
	["Riverhold"]                           = 665,
	["Hakoshae Tombs"]                      = 666,
	["Merryvale Sugar Farm Caves"]          = 667,
	["Skooma Cat's Cloister"]               = 668,
	["Rimmen Palace Crypts"]                = 669,
	["Rimmen Palace"]                       = 670,
	["Rimmen Palace Courtyard"]             = 671,
	["Dov-Vahl Shrine"]                     = 672,
	["Sepulcher of Mischance"]              = 673,
	["Shadow Dance Temple"]                 = 674,
	["Vault of Heavenly Scourge"]           = 675,
	["Moon Gate of Anequina"]               = 676,
	["Jode's Core"]                         = 677,
	["Darkpool Mine"]                       = 678,
	["The Tangle"]                          = 679,
	
		-- SOUTHERN ELSWEYR
	["Wind Scour Temple"]                   = 680,
	["Storm Talon Temple"]                  = 681,
	["Dark Water Temple"]                   = 682,
	["Vahlokzin's Domain"]                  = 683,
	["Vahlokzin's Lair"]                    = 684,
	["Senchal"]                             = 685,
	["Senchal Outlaws Refuge"]              = 686,
	["Senchal Palace"]                      = 687,
	["Southern Elsweyr"]                    = 688,
	["Tideholm"]                            = 689,
	["Dragonguard Sanctum"]                 = 690,
	["Moonlit Cove"]                        = 691,
	["Passage of Dad'na Ghaten"]            = 692,
	["Zazardi's Quarry and Mine"]           = 693,
	["Black Kiergo Arena"]                  = 694,
	["Forsaken Citadel"]                    = 695,
	["New Moon Fortress"]                   = 696,
	["Halls of the Highmane"]               = 697,
	["Path of Pride"]                       = 698,
	["Doomstone Keep"]                      = 699,
	["The Spilled Sand"]                    = 700,
	["Dragonhold"]                          = 701,
	["Jonelight Path"]                      = 702,

	-- WESTERN SKYRIM
	["Riften Ratway"]                       = 703,
	["Blackreach: Mzark Cavern"]            = 704,
	["Palace of Kings"]                     = 705,
	["Western Skyrim"]                      = 706,
	["Solitude"]                            = 707,
	["Kilkreath"]                           = 708,
	["Shadowgreen"]                         = 709,
	["Dragon Bridge Smuggler Caves"]        = 710,
	["Dragonhome"]                          = 711,
	["Mor Khazgur Mine"]                    = 712,
	["Chillwind Depths"]                    = 713,
	["Bleakridge Barrow"]                   = 714,
	["Red Eagle Ridge"]                     = 715,
	["Verglas Hollow"]                      = 716,
	["Frozen Coast"]                        = 717,
	["Morthal Barrow"]                      = 718,
	["Blackreach: Greymoor Caverns"]        = 719,
	["Kagnthamz"]                           = 720,
	["Tzinghalis"]                          = 721,
	["Lightless Hollow Mine"]               = 722,
	["Bthang Outpost"]                      = 723,
	["Blackreach: Dark Moon Grotto"]        = 724,
	["The Scraps"]                          = 725,
	["Might Barrow"]                        = 726,
	["The Undergrove"]                      = 727,
	["Greymoor Keep: West Wing"]            = 728,
	["Greymoor Keep"]                       = 729,
	["Gray Host Tunnels"]                   = 730,

	-- THE REACH
	["Gray Host Sanctuary"]                 = 731,
	["Grayhome"]                            = 732,
	["Castle Grayhome"]                     = 733,
	["Grayhome Ritual Chamber"]             = 734,
	["The Reach"]                           = 735,
	["Markarth"]                            = 736,
	["Understone Keep"]                     = 737,
	["Valthume"]                            = 738,
	["Reachwind Depths"]                    = 739,
	["Briar Rock Ruins"]                    = 740,
	["Briar Rock Crypts"]                   = 741,
	["Dead Crone Tower"]                    = 742,
	["Sanuarach Mine"]                      = 743,
	["Bthar-Zel"]                           = 744,
	["Bthar-Zel Bank"]                      = 745,
	["Bthar-Zel Vault"]                     = 746,
	["Lost Valley Redoubt"]                 = 747,
	["The Dark Descent"]                    = 748,
	["Gloomreach"]                          = 749,
	["Blackreach: Arkthzand"]               = 750,
	["Halls of Arkthzand"]                  = 751,
	["Nighthollow Keep"]                    = 752,
	["Chamber of the Dark Heart"]           = 753,
	["Nchuand-Zel"]                         = 754,
	["Arkthzand Orrery"]                    = 755,
	["Gray Haven"]                          = 756,
	
	-- Isle of Balfiera
	["Balfiera Ruins"]                      = 757,
	["Isle of Balfiera"]                    = 758,
	["Keywright's Gallery"]                 = 759,
	
		-- Blackwood
	["Imperial Cache Annex"]                = 760,
	["Ne Salas Cache Annex"]                = 761,
	["Imperial Sewers"]                     = 762,
	["Deadlands"]                           = 763,
	["Leyawiin"]                            = 764,
	["Blackwood"]                           = 765,
	["Undertow Cavern"]                     = 766,
	["Borderwatch Sewers"]                  = 767,
	["Borderwatch Courtyard"]               = 768,
	["Borderwatch Keep"]                    = 769,
	["Borderlands Crypt"]                   = 770,
	["Ayleid Ruins"]                        = 771,
	["Veyond"]                              = 772,
	["Deepscorn Hollow"]                    = 773,
	["Gideon"]                              = 774,
	["Twyllbek Ruins"]                      = 775,
	["Tidewater Cave"]                      = 776,
	["Glenbridge Xanmeer"]                  = 777,
	["Doomvault Porcixid"]                  = 778,
	["Xal Irasotl"]                         = 779,
	["Bloodrun Cave"]                       = 780,
	["Welke"]                               = 781,
	["Leyawiin Castle"]                     = 782,
	["Xi-Tsei"]                             = 783,
	["Stonewastes Keep"]                    = 784,
	["Doomvault Capraxus"]                  = 785,
	["Vandacia's Deadline Keep"]            = 786,
	["Ruction Ring"]                        = 787,
	["Vunalk1"]                             = 788,
	["Deadlands: The Ashen Forest"]         = 789,
	["White Gold Tower Throne Room"]        = 790,
	["Xynaa's Sanctuary"]                   = 791,
	["Arpenia"]                             = 792,
	["Doomvault Vulpinaz Upper level"]      = 793,
	["Doomvault Vulpinaz Mid Level"]        = 794,
	["Doomvault Vulpinaz Lower Level"]      = 795,
	["Anchor Chamber"]                      = 796,
	["Fort Redmane"]                        = 797,
}

-----------------------------------------
-- HELPER FUNCTIONS
-----------------------------------------

function Data:CollectMapIds()
	local sv = ZGV.sv.profile
	sv.mapids = {}

	for i = 0,1000 do
		local loczone, _ = _G.GetZoneInfo(i)
		sv.mapids[loczone] = i
	end
end
