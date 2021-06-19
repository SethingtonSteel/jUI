local Location = FasterTravel.Location
local Utils = FasterTravel.Utils
local Options = FasterTravel.Options

local ALLIANCE_ALL = -2147483646
local ALLIANCE_SHARED = -2147483647
local ALLIANCE_WORLD = -2147483648

local LocationDirection = Options.LocationDirection
local LocationOrder = Options.LocationOrder
local AllWSOrder = Options.AllWSOrder

local _factionZoneOrderLookup = {
	[ALLIANCE_ALDMERI_DOMINION] = {
		"khenarthisroost","auridon","grahtwood","greenshade","malabaltor","reapersmarch",
	},
	[ALLIANCE_DAGGERFALL_COVENANT] = {
		"strosmkai","betnihk","glenumbra","stormhaven","rivenspire","alikr","bangkorai",
	},
	[ALLIANCE_EBONHEART_PACT] = {
		"bleakrock","balfoyen","stonefalls","deshaan","shadowfen","eastmarch","therift",
	},
	[ALLIANCE_ALL] = { "cyrodiil" },
	[ALLIANCE_SHARED] = {
		"coldharbor", "craglorn", "eyevea", "artaeum",
		"hewsbane", "goldcoast", "imperialcity", "wrothgar", 
		 "vvardenfell", 
		"clockwork", "brassfortress",
		"murkmire", "norgtzel",
		"summerset",
		"elsweyr", "southernelsweyr", "tideholm", 
		"westernskyrim", "blackreach", 
		"u28_blackreach", "reach", 
		"blackwood",
	},
	[ALLIANCE_WORLD] = { "tamriel", "mundus", }
}

local _factionAllianceOrderLookup = {
	[ALLIANCE_ALDMERI_DOMINION] = {
		ALLIANCE_ALL, ALLIANCE_ALDMERI_DOMINION,
		ALLIANCE_EBONHEART_PACT, ALLIANCE_DAGGERFALL_COVENANT, ALLIANCE_SHARED, ALLIANCE_WORLD
	},
	[ALLIANCE_DAGGERFALL_COVENANT] = {
		ALLIANCE_ALL, ALLIANCE_DAGGERFALL_COVENANT, 
		ALLIANCE_ALDMERI_DOMINION, ALLIANCE_EBONHEART_PACT, ALLIANCE_SHARED, ALLIANCE_WORLD
	},
	[ALLIANCE_EBONHEART_PACT] = {
		ALLIANCE_ALL, ALLIANCE_EBONHEART_PACT,
		ALLIANCE_DAGGERFALL_COVENANT, ALLIANCE_ALDMERI_DOMINION, ALLIANCE_SHARED, ALLIANCE_WORLD
	}
}

local _factionAllianceIcons = {
	[ALLIANCE_ALDMERI_DOMINION] = "/esoui/art/compass/ava_borderkeep_pin_aldmeri.dds",
	[ALLIANCE_DAGGERFALL_COVENANT] = "/esoui/art/compass/ava_borderkeep_pin_daggerfall.dds",
	[ALLIANCE_EBONHEART_PACT] = "/esoui/art/compass/ava_borderkeep_pin_ebonheart.dds",
	[ALLIANCE_ALL] = "/esoui/art/compass/ava_3way.dds",
	[ALLIANCE_SHARED] = "/esoui/art/compass/ava_outpost_neutral.dds",
	[ALLIANCE_WORLD] = "/esoui/art/ava/ava_rankicon_palatine.dds"
}

-- generated locations list
local _locationsList = {
	{["subzone"] = "tamriel",			["zone"] = "tamriel",			["mapIndex"] = 1,	["zoneIndex"] = -2147483648,	["name"] = "Tamriel",						["key"] = "tamriel/tamriel",					["tile"] = "art/maps/tamriel/tamriel_0.dds",				},
	{["subzone"] = "glenumbra",			["zone"] = "glenumbra",			["mapIndex"] = 2,	["zoneIndex"] = 2,				["name"] = "Glenumbra",						["key"] = "glenumbra/glenumbra",				["tile"] = "art/maps/glenumbra/glenumbra_base_0.dds",		},
	{["subzone"] = "rivenspire",		["zone"] = "rivenspire",		["mapIndex"] = 3,	["zoneIndex"] = 5,				["name"] = "Rivenspire",					["key"] = "rivenspire/rivenspire",				["tile"] = "art/maps/rivenspire/rivenspire_base_0.dds",		},
	{["subzone"] = "stormhaven",		["zone"] = "stormhaven",		["mapIndex"] = 4,	["zoneIndex"] = 4,				["name"] = "Stormhaven",					["key"] = "stormhaven/stormhaven",				["tile"] = "art/maps/stormhaven/stormhaven_base_0.dds",		},
	{["subzone"] = "alikr",				["zone"] = "alikr",				["mapIndex"] = 5,	["zoneIndex"] = 17,				["name"] = "Alik'r Desert",					["key"] = "alikr/alikr",						["tile"] = "art/maps/alikr/alikr_base_0.dds",				},
	{["subzone"] = "bangkorai",			["zone"] = "bangkorai",			["mapIndex"] = 6,	["zoneIndex"] = 14,				["name"] = "Bangkorai",						["key"] = "bangkorai/bangkorai",				["tile"] = "art/maps/bangkorai/bangkorai_base_0.dds",		},
	{["subzone"] = "grahtwood",			["zone"] = "grahtwood",			["mapIndex"] = 7,	["zoneIndex"] = 180,			["name"] = "Grahtwood",						["key"] = "grahtwood/grahtwood",				["tile"] = "art/maps/grahtwood/grahtwood_base_0.dds",		},
	{["subzone"] = "malabaltor",		["zone"] = "malabaltor",		["mapIndex"] = 8,	["zoneIndex"] = 11,				["name"] = "Malabal Tor",					["key"] = "malabaltor/malabaltor",				["tile"] = "art/maps/malabaltor/malabaltor_base_0.dds",		},
	{["subzone"] = "shadowfen",			["zone"] = "shadowfen",			["mapIndex"] = 9,	["zoneIndex"] = 19,				["name"] = "Shadowfen",						["key"] = "shadowfen/shadowfen",				["tile"] = "art/maps/shadowfen/shadowfen_base_0.dds",		},
	{["subzone"] = "deshaan",			["zone"] = "deshaan",			["mapIndex"] = 10,	["zoneIndex"] = 10,				["name"] = "Deshaan",						["key"] = "deshaan/deshaan",					["tile"] = "art/maps/deshaan/deshaan_base_0.dds",			},
	{["subzone"] = "stonefalls",		["zone"] = "stonefalls",		["mapIndex"] = 11,	["zoneIndex"] = 9,				["name"] = "Stonefalls",					["key"] = "stonefalls/stonefalls",				["tile"] = "art/maps/stonefalls/stonefalls_base_0.dds",		},
	{["subzone"] = "therift",			["zone"] = "therift",			["mapIndex"] = 12,	["zoneIndex"] = 16,				["name"] = "The Rift",						["key"] = "therift/therift",					["tile"] = "art/maps/therift/therift_base_0.dds",			},
	{["subzone"] = "eastmarch",			["zone"] = "eastmarch",			["mapIndex"] = 13,	["zoneIndex"] = 15,				["name"] = "Eastmarch",						["key"] = "eastmarch/eastmarch",				["tile"] = "art/maps/eastmarch/eastmarch_base_0.dds",		},
	{["subzone"] = "ava",				["zone"] = "cyrodiil",			["mapIndex"] = 14,	["zoneIndex"] = 37,				["name"] = "Cyrodiil",						["key"] = "cyrodiil/ava",						["tile"] = "art/maps/cyrodiil/ava_whole_0.dds",				},
	{["subzone"] = "auridon",			["zone"] = "auridon",			["mapIndex"] = 15,	["zoneIndex"] = 178,			["name"] = "Auridon",						["key"] = "auridon/auridon",					["tile"] = "art/maps/auridon/auridon_base_0.dds",			},
	{["subzone"] = "greenshade",		["zone"] = "greenshade",		["mapIndex"] = 16,	["zoneIndex"] = 18,				["name"] = "Greenshade",					["key"] = "greenshade/greenshade",				["tile"] = "art/maps/greenshade/greenshade_base_0.dds",		},
	{["subzone"] = "reapersmarch",		["zone"] = "reapersmarch",		["mapIndex"] = 17,	["zoneIndex"] = 179,			["name"] = "Reaper's March",				["key"] = "reapersmarch/reapersmarch",			["tile"] = "art/maps/reapersmarch/reapersmarch_base_0.dds",	},
	{["subzone"] = "balfoyen",			["zone"] = "stonefalls",		["mapIndex"] = 18,	["zoneIndex"] = 110,			["name"] = "Bal Foyen",						["key"] = "stonefalls/balfoyen",				["tile"] = "art/maps/stonefalls/balfoyen_base_0.dds",		},
	{["subzone"] = "strosmkai",			["zone"] = "glenumbra",			["mapIndex"] = 19,	["zoneIndex"] = 304,			["name"] = "Stros M'Kai",					["key"] = "glenumbra/strosmkai",				["tile"] = "art/maps/Glenumbra/strosmkai_base_0.dds",		},
	{["subzone"] = "betnihk",			["zone"] = "glenumbra",			["mapIndex"] = 20,	["zoneIndex"] = 305,			["name"] = "Betnikh",						["key"] = "glenumbra/betnihk",					["tile"] = "art/maps/Glenumbra/betnihk_base_0.dds",			},
	{["subzone"] = "khenarthisroost",	["zone"] = "auridon",			["mapIndex"] = 21,	["zoneIndex"] = 306,			["name"] = "Khenarthi's Roost",				["key"] = "auridon/khenarthisroost",			["tile"] = "art/maps/auridon/khenarthisroost_base_0.dds",	},
	{["subzone"] = "bleakrock",			["zone"] = "stonefalls",		["mapIndex"] = 22,	["zoneIndex"] = 109,			["name"] = "Bleakrock Isle",				["key"] = "stonefalls/bleakrock",				["tile"] = "art/maps/stonefalls/bleakrock_base_0.dds",		},
	{["subzone"] = "coldharbour",		["zone"] = "coldharbor",		["mapIndex"] = 23,	["zoneIndex"] = 154,			["name"] = "Coldharbour",					["key"] = "coldharbor/coldharbour",				["tile"] = "art/maps/coldharbor/coldharbour_base_0.dds",	},
	{["subzone"] = "mundus",			["zone"] = "tamriel",			["mapIndex"] = 24,	["zoneIndex"] = -2147483648,	["name"] = "The Aurbis",					["key"] = "tamriel/mundus",						["tile"] = "art/maps/tamriel/mundus_base_0.dds",			},
	{["subzone"] = "craglorn",			["zone"] = "craglorn",			["mapIndex"] = 25,	["zoneIndex"] = 500,			["name"] = "Craglorn",						["key"] = "craglorn/craglorn",					["tile"] = "art/maps/craglorn/craglorn_base_0.dds",			},
	{["subzone"] = "imperialcity",		["zone"] = "cyrodiil",			["mapIndex"] = 26,	["zoneIndex"] = 346,			["name"] = "Imperial City",					["key"] = "cyrodiil/imperialcity",				["tile"] = "art/maps/cyrodiil/imperialcity_base_0.dds",		},
	{["subzone"] = "wrothgar",			["zone"] = "wrothgar",			["mapIndex"] = 27,	["zoneIndex"] = 379,			["name"] = "Wrothgar",						["key"] = "wrothgar/wrothgar",					["tile"] = "art/maps/wrothgar/wrothgar_base_0.dds",			},
	{["subzone"] = "hewsbane",			["zone"] = "thievesguild",		["mapIndex"] = 28,	["zoneIndex"] = 442,			["name"] = "Hew's Bane",					["key"] = "thievesguild/hewsbane",				["tile"] = "art/maps/thievesguild/hewsbane_base_0.dds",		},
	{["subzone"] = "goldcoast",			["zone"] = "darkbrotherhood",	["mapIndex"] = 29,	["zoneIndex"] = 448,			["name"] = "Gold Coast",					["key"] = "darkbrotherhood/goldcoast",			["tile"] = "art/maps/darkbrotherhood/goldcoast_base_0.dds",	},
	{["subzone"] = "vvardenfell",		["zone"] = "vvardenfell",		["mapIndex"] = 30,	["zoneIndex"] = 467,			["name"] = "Vvardenfell",					["key"] = "vvardenfell/vvardenfell",			["tile"] = "art/maps/vvardenfell/vvardenfell_base_0.dds",	},
	{["subzone"] = "clockwork",			["zone"] = "clockwork",			["mapIndex"] = 31,	["zoneIndex"] = 589,			["name"] = "Clockwork City",				["key"] = "clockwork/clockwork",				["tile"] = "art/maps/clockwork/clockwork_base_0.dds",		},
	{["subzone"] = "brassfortress",		["zone"] = "clockwork",			["mapIndex"] = nil,	["zoneIndex"] = 590,			["name"] = "The Brass Fortress",			["key"] = "clockwork/brassfortress",			["tile"] = "art/maps/clockwork/brassfortress_base_0.dds",	},
	{["subzone"] = "summerset",			["zone"] = "summerset",			["mapIndex"] = 32,	["zoneIndex"] = 616,			["name"] = "Summerset",						["key"] = "summerset/summerset",				["tile"] = "art/maps/summerset/summerset_base_0.dds",		},
	{["subzone"] = "artaeum",			["zone"] = "summerset",			["mapIndex"] = 33,	["zoneIndex"] = 632,			["name"] = "Artaeum",						["key"] = "summerset/artaeum",					["tile"] = "art/maps/summerset/artaeum_base_0.dds",			},
	{["subzone"] = "murkmire",			["zone"] = "murkmire",			["mapIndex"] = 34,	["zoneIndex"] = 407,			["name"] = "Murkmire",						["key"] = "murkmire/murkmire",					["tile"] = "art/maps/murkmire/murkmire_base_0.dds",			},
	{["subzone"] = "norgtzel",			["zone"] = "norgtzel",			["mapIndex"] = 35,	["zoneIndex"] = 667,			["name"] = "Norg-Tzel",						["key"] = "norgtzel/norgtzel",					["tile"] = "art/maps/norgtzel/norgtzel_base_0.dds",			},
	{["subzone"] = "elsweyr",			["zone"] = "elsweyr",			["mapIndex"] = 36,	["zoneIndex"] = 681,			["name"] = "Northern Elsweyr",				["key"] = "elsweyr/elsweyr",					["tile"] = "art/maps/elsweyr/elsweyr_base_0.dds",			},
	{["subzone"] = "southernelsweyr",	["zone"] = "southernelsweyr",	["mapIndex"] = 37,	["zoneIndex"] = 720,			["name"] = "Southern Elsweyr",				["key"] = "southernelsweyr/southernelsweyr",	["tile"] = "art/maps/southernelsweyr/southernelsweyr_base_0.dds",},
	{["subzone"] = "tideholm",			["zone"] = "southernelsweyr",	["mapIndex"] = nil,	["zoneIndex"] = 733,			["name"] = "Tideholm",						["key"] = "southernelsweyr/tideholm",			["tile"] = "art/maps/southernelsweyr/tideholm_base_0.dds",	},
	{["subzone"] = "westernskyrim",		["zone"] = "skyrim",			["mapIndex"] = 38,	["zoneIndex"] = 743,			["name"] = "Western Skyrim",				["key"] = "skyrim/westernskyrim",				["tile"] = "art/maps/skyrim/westernskyrim_base_0.dds",		},
	{["subzone"] = "blackreach",		["zone"] = "skyrim",			["mapIndex"] = 39,	["zoneIndex"] = 744,			["name"] = "Blackreach: Greymoor Caverns",	["key"] = "skyrim/blackreach",					["tile"] = "art/maps/skyrim/blackreach_base_0.dds",			},
--	{["subzone"] = "blackreach",		["zone"] = "skyrim",			["mapIndex"] = 40,	["zoneIndex"] = 745,			["name"] = "Blackreach",					["key"] = "skyrim/blackreach",					["tile"] = "art/maps/skyrim/blackreach_base_0.dds",			},
	{["subzone"] = "u28_blackreach",	["zone"] = "reach",				["mapIndex"] = 41,	["zoneIndex"] = 783,			["name"] = "Blackreach: Arkthzand Cavern",	["key"] = "reach/u28_blackreach",				["tile"] = "art/maps/reach/U28_blackreach_base_0.dds",		},
	{["subzone"] = "reach",				["zone"] = "reach",				["mapIndex"] = 42,	["zoneIndex"] = 784,			["name"] = "The Reach",						["key"] = "reach/reach",						["tile"] = "art/maps/reach/reach_base_0.dds",				},
	{["subzone"] = "blackwood",			["zone"] = "blackwood",			["mapIndex"] = 43,	["zoneIndex"] = 834,			["name"] = "Blackwood",						["key"] = "reach/reach",						["tile"] = "art/maps/blackwood/blackwood_base_0.dds",		},
	{ -- manually added
		["zoneIndex"] = 99,
		["name"] = "Eyevea",
		["tile"] = "art/maps/guildmaps/eyevea_base_0.dds",
		["click"] = function()        
			zo_callLater(function() 
				ProcessMapClick(0.077777777777778,0.58395061728395)
				CALLBACK_MANAGER:FireCallbacks("OnWorldMapChanged")
			end,1)
		end
	}
}

-- add localized zone names
for i, v in ipairs(_locationsList) do
	v.name = Utils.FormatStringCurrentLanguage(GetZoneNameByIndex(v.zoneIndex))
end

local ZONE_INDEX_CYRODIIL = 37

local _locations
local _locationsLookup
local _zoneFactionLookup

local _zoneIdReverseLookup = {}
for zoneIndex=0, GetNumZones() do
    local zoneId = GetZoneId(zoneIndex)
	local zoneName = Utils.FormatStringCurrentLanguage(GetZoneNameById(zoneId))
	_zoneIdReverseLookup[zoneName] = zoneId
end
	
local function GetZoneIdByName(name)
	return _zoneIdReverseLookup[name]
end

local function GetMapZone(path)
	path = path or GetMapTileTexture()
	path = path:lower():gsub('_0.dds', ''):gsub('_whole', ''):gsub('_base' ,'')
	local zone,subzone = string.match(path,"^.-/.-/(.-)/(.+)")
	if zone == nil and subzone == nil then 
		-- splits if path is actually a zone key 
		zone,subzone = string.match(path,"^(.-)/(.-)$")
	end
	return zone,subzone
end

local function GetMapZoneKey(zone,subzone)
	if zone == nil and subzone == nil then 
		zone,subzone = GetMapZone()
	elseif subzone == nil then
		zone,subzone = GetMapZone(zone)
	end
	return table.concat({zone,"/",subzone}),zone,subzone
end

local function GetList()
	if _locations == nil then
		_locations = {}
		for i,loc in ipairs(_locationsList) do
			local l = {}
			local name 
			if loc.mapIndex ~= nil then
 				name = GetMapInfo(loc.mapIndex)
			end
			if name == nil then
				name = GetZoneNameByIndex(loc.zoneIndex)
			end
			l.name = Utils.FormatStringCurrentLanguage(name) -- cache not required as this as the locations list itself is a cache =)
			l.barename = Utils.BareName(name)
			l.key,l.zone,l.subzone = GetMapZoneKey(loc.tile)
			l.mapIndex, l.zoneIndex, l.tile = loc.mapIndex, loc.zoneIndex, loc.tile
			table.insert(_locations, l)
		end
		table.sort(_locations,function(x,y)	return x.name < y.name end)
	end 
	return _locations
end

local function CreateLocationsLookup(locations,func)
	local lookup = {}
	func = func or function(l) return l end 
	local item
	for i,loc in ipairs(locations) do 
		item = func(loc)
		lookup[loc.zoneIndex] = item
		lookup[loc.key] = item
		if lookup[loc.subzone] == nil then 
			lookup[loc.subzone] = item
		elseif lookup[loc.zone] == nil then 
			lookup[loc.zone] = item
		end
	end
	for i,loc in ipairs(locations) do 
		if lookup[loc.zone] == nil then 
			lookup[loc.zone] = lookup[loc.zoneIndex]
		end
	end
	return lookup
end

local function GetLookup()
	if _locationsLookup == nil then
		_locationsLookup = CreateLocationsLookup(GetList())
	end 
	return _locationsLookup
end

local function GetZoneLocation(lookup,zone,subzone)
	local loc
	if type(zone) == "number" then 
		loc = lookup[zone]
		zone = nil 
	end 
	if loc == nil then
		local key,zone,subzone = Location.Data.GetMapZoneKey(zone,subzone)
		-- try by zone/subzone key first
		loc = lookup[key]
		-- subzone next to handle places like khenarthis roost
		if loc == nil then
			loc = lookup[subzone]
		end
		-- then zone to handle locations within main zones which cannot be matched by key e.g coldharbor's hollow city
		if loc == nil then 
			loc = lookup[zone]
		end 
	end 
	-- if zone can't be found, return tamriel
	if loc == nil then 
		loc = lookup["tamriel"]
	end
	return loc
end

local function IsZoneIndexCyrodiil(zoneIndex)
	return zoneIndex == ZONE_INDEX_CYRODIIL
end

local function IsCyrodiil(loc)
	if loc == nil then return end 
	return IsZoneIndexCyrodiil(loc.zoneIndex)
end

local function GetZoneFactionLookup()
	local zoneLookup = GetLookup()
	if _zoneFactionLookup == nil then 
		local lookup = {}
		for faction,zones in pairs(_factionZoneOrderLookup) do
			for i,zone in ipairs(zones) do
				z = zoneLookup[zone]
				if z == nil then 
					d("nil at", zone)				
				else
					lookup[z] = faction
				end
			end
		end
		_zoneFactionLookup = lookup
	end 
	return _zoneFactionLookup
end 

local function GetZoneFaction(loc)
	local lookup = GetZoneFactionLookup()
	return lookup[loc]
end 

local function GetAllianceZones(alliance, lookup,sortFunc)
	local zones = _factionZoneOrderLookup[alliance]
	zones = Utils.map(zones,function(key) return lookup[key] end)
	if sortFunc ~= nil then 
		table.sort(zones,sortFunc)
	end
	return zones
end

local function IsFactionWorldOrShared(faction)
	return faction == ALLIANCE_SHARED or faction == ALLIANCE_WORLD or faction == ALLIANCE_ALL
end

local function GetFactionOrderedList(faction,lookup,args)
	args = args or {}
	local zoneSortFunc = args.zoneSortFunc
	local allianceSortFunc = args.allianceSortFunc
	local transform = args.transform
	local alliances = Utils.copy(_factionAllianceOrderLookup[faction])
	if allianceSortFunc ~= nil then 
		table.sort(alliances,allianceSortFunc)
	end 
	local list = {}
	local zones
	for i,alliance in ipairs(alliances) do 
		zones = GetAllianceZones(alliance,lookup,zoneSortFunc)
		if transform ~= nil then 
			zones = transform(alliance,zones) or {}
		end 
		Utils.copy(zones,list)
	end
	return list
end

local function GetDirectionValue(direction,x,y)
	-- Cyrodiil sorts before other zones
	if IsZoneIndexCyrodiil(x.zoneIndex) and not IsZoneIndexCyrodiil(y.zoneIndex) then
		return true
	elseif IsZoneIndexCyrodiil(y.zoneIndex) then 
		return false
	elseif direction == LocationDirection.ASCENDING then
		return Utils.BareName(x.name) < Utils.BareName(y.name)
	elseif direction == LocationDirection.DESCENDING then
		return Utils.BareName(y.name) < Utils.BareName(x.name)
	end 
end

local function AddSharedAndWorld(tbl,lookup,sortFunc)
	local shared = GetAllianceZones(ALLIANCE_SHARED,lookup)
	local world = GetAllianceZones(ALLIANCE_WORLD,lookup)
	local newtbl = {}
	Utils.copy(tbl,    newtbl)
	Utils.copy(shared, newtbl)
	Utils.copy(world,  newtbl)
	return newtbl
end

local _locationSortOrder = {
	[LocationOrder.ZONE_NAME] = function(direction,currentFaction)
		local list = Utils.copy(GetList())
		table.sort(list,function(x,y)
			return GetDirectionValue(direction,x,y)
		end)
		return list
	end,
	[LocationOrder.ZONE_LEVEL] = function(direction,currentFaction)
		local lookup = GetLookup()
		local tbl = GetFactionOrderedList(currentFaction, lookup, {
			transform = function(alliance,zones)
				if direction == LocationDirection.DESCENDING and
					not IsFactionWorldOrShared(alliance) and
					alliance ~= ALLIANCE_ALL then 
					return Utils.reverseTable(zones)
				end 
				return zones
			end 
		})
		return tbl
	end
}

local function UpdateLocationOrder(locations,order,...)
	local newList 
	local direction = order % 2
	local sortfunc = _locationSortOrder[order - direction] 
	if sortfunc ~= nil then 
		newList = sortfunc(direction,...)
		if newList ~= nil then
			for i = 1, #locations do
				locations[i] = nil
			end
			for i,v in ipairs(newList) do
				locations[#locations+1] = v 
			end
		end
	end
end

local function GetZoneFactionIcon(loc)
	local faction = GetZoneFaction(loc)
	return _factionAllianceIcons[faction]
end

local Data = {}
Data.ZONE_INDEX_CYRODIIL = ZONE_INDEX_CYRODIIL
Data.GetZoneIdByName = GetZoneIdByName
Data.GetMapZoneKey = GetMapZoneKey
Data.GetList = GetList
Data.GetLookup = GetLookup
Data.GetZoneLocation = GetZoneLocation
Data.IsZoneIndexCyrodiil = IsZoneIndexCyrodiil
Data.IsCyrodiil = IsCyrodiil
Data.GetZoneFaction = GetZoneFaction
Data.GetFactionOrderedList = GetFactionOrderedList
Data.IsFactionWorldOrShared = IsFactionWorldOrShared
Data.LocationOrder = LocationOrder
Data.UpdateLocationOrder = UpdateLocationOrder
Data.GetZoneFactionIcon = GetZoneFactionIcon
FasterTravel.Location.Data = Data
	
	