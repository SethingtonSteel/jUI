local DTAddon = _G['DTAddon']
local pLF = LibPhinixFunctions.LangFormat
DTAddon.Strings = DTAddon:GetLanguage()

DTAddon.aOpts = {
	showhM = true,						-- show hard mode completion
	showtT = true,						-- show time trial completion
	shownD = true,						-- show no death completion
	showGFComp = true,					-- dungeon faction completion
	cColorT = {0,1,0.02,1},				-- completed achievement name color
	cColorS = "00ff05",					-- completed achievement name color (text hex)
	iColorT = {0.48,0.48,0.48,1},		-- incomplete achievement name color
	iColorS = "7a7a7a",					-- incomplete achievement name color (text hex)
	sortAlpha = true,					-- alphabetize completion lists
	kSformat = 1,						-- format for completion text
	showLFGt = true,					-- lfg: show dungeon completion
	showLFGd = true,					-- lfg: show dungeon description
	showNComp = true,					-- map: normal dungeon completion
	showVComp = true,					-- map: veteran dungeon completion
	showGCComp = true,					-- map: delve group challenge completion
	showDBComp = true,					-- map: delve boss completion
	showDFComp = true,					-- map: delve faction completion
	compDB = {},						-- database of all achievement completion values by unique character ID (see AchievementDB.lua)
}

DTAddon.cOpts = {
	trackChar = true,					-- achievement completion tracking status (per-character)
}

local pChars = {
	["Dar'jazad"] = "Rajhin's Echo",
	["Quantus Gravitus"] = "Maker of Things",
	["Nina Romari"] = "Sanguine Coalescence",
	["Valyria Morvayn"] = "Dragon's Breath",
	["Sanya Lightspear"] = "Glacial Fortress",
	["Divad Arbolas"] = "Gravity of Words",
	["Dro'samir"] = "Dark Matter",
	["Irae Aundae"] = "Prismatic Inversion",
	["Quixoti'coatl"] = "Winds of Time",
	["Cythirea"] = "Mazken Stormclaw",
	["Fear-No-Pain"] = "Soul Sap",
	["Wax-in-Winter"] = "Entropic Regenesis",
	["Nateo Mythweaver"] = "In Strange Lands",
	["Cindari Atropa"] = "Dragon's Teeth",
	["Kailyn Duskwhisper"] = "Nowhere's End",
	["Draven Blightborn"] = "From Outside",
	["Lorein Tarot"] = "Free Association",
}

local function modifyTitle(oTitle, uName)
	local tLang = {
		en = "Volunteer",
		fr = "Volontaire",
		de = "Freiwillige",
	}
	local client = GetCVar("Language.2")
	if oTitle == tLang[client] then
		return (pChars[uName] ~= nil) and pChars[uName] or oTitle
	end
	return oTitle
end

local modifyGetTitle = GetTitle
GetTitle = function(index)
	local oTitle = modifyGetTitle(index)
	local uName = pLF(GetUnitName('player'))
	local rTitle = modifyTitle(oTitle, uName)
	return rTitle
end

local modifyGetUnitTitle = GetUnitTitle
GetUnitTitle = function(unitTag)
	local oTitle = modifyGetUnitTitle(unitTag)
	local uName = pLF(GetUnitName(unitTag))
	local rTitle = modifyTitle(oTitle, uName)
	return rTitle
end
