local surveySign		= "+"
local treasureSign		= "*"
local surveyColor       = "00ff80" -- RRGGBB
local treasureColor     = "ffff00"

local SurveyTheWorld 	= {}
STW 					= SurveyTheWorld
STW.surveyNames 		= {}
STW.treasureNames 		= {}
local treasure 			= SPECIALIZED_ITEMTYPE_TROPHY_TREASURE_MAP
local survey 			= SPECIALIZED_ITEMTYPE_TROPHY_SURVEY_REPORT
local em				= EVENT_MANAGER

local orgFunction

local function buildSurveyNameList()
	local surveyNames 		= {}
	local treasureNames 	= {}
	local bagId  = BAG_BACKPACK
	local numBagSlots = GetBagSize(bagId)
	for slotId = 0, numBagSlots do	
		local itemType, sItemType = GetItemType(bagId, slotId)
		if itemType == ITEMTYPE_TROPHY and (sItemType == treasure or sItemType == survey) then 
			local itemName = zo_strformat(GetItemName(bagId, slotId)):match("^%s*(.-)%s*$")
			if sItemType == survey then
				table.insert(surveyNames, itemName)
			else
				table.insert(treasureNames, itemName)
			end
		end
	end	
	STW.surveyNames		= surveyNames
	STW.treasureNames	= treasureNames
end
STW.buildSurveyNameList = buildSurveyNameList

local function countInList(which, zoneName)
	-- <zonename> (CE)? Treasure Map (<roman>) | <type> Survey: <zonename> <roman>?
	-- special cases: Orsinium = Wrothgar, Alik'r = Alik'r Desert, Bleakrock = Bleakrock Isle
	if string.match(zoneName, "Alik'r") then zoneName = "Alik'r" 
	elseif string.match(zoneName, "Алик'р") then zoneName = "Алик'р" 
	elseif string.match(zoneName, "Wrothgar") and which == "t" then zoneName = "Orsinium"
	elseif string.match(zoneName, "Ротгар") and which == "t" then zoneName = "Орсиниум"
	elseif string.match(zoneName, "Bleakrock Isle") and which == "t" then zoneName = "Bleakrock"
	end
	if which == "s" then
		list = STW.surveyNames
	else
		list = STW.treasureNames
	end
	count = 0
	for index, name in pairs(list) do
		if string.match(name, zoneName) then count = count + 1 end
	end
	return count
end
STW.countInList = countInList

local function getCountersFor(zoneName)
    surveys = countInList("s", zoneName)
	treasures = countInList("t", zoneName)
	local sign = (surveys > 0 and ("|c" .. surveyColor .. surveySign .. "|r") or "") ..
	             (treasures > 0 and ("|c" .. treasureColor .. treasureSign .. "|r") or "")
	return 	surveys > 0 and "|c" .. surveyColor .. "(" .. tostring(surveys) .. ")|r" or "",
			treasures > 0 and "|c" .. treasureColor .. "(" .. tostring(treasures) .. ")|r" or "",
			sign
end
STW.getCountersFor = getCountersFor

local function escapeZoneName(zoneName)
	zoneName = zoneName:gsub("^%A*", "")
	return zoneName
end

local function onSlotUpdate(eventCode, bagId, slotId, isNewItem)
	if bagId ~= BAG_BACKPACK then return end
	if isNewItem then 
		local itemType, sItemType = GetItemType(bagId, slotId)
		if itemType == ITEMTYPE_TROPHY and (sItemType == treasure or sItemType == survey) then 
			STW.buildSurveyNameList()
		end
	else
		STW.buildSurveyNameList() 
	end
end

local function registerEvents()
	em:RegisterForEvent("SurveyTheWorld", 	EVENT_PLAYER_ACTIVATED, 			buildSurveyNameList)
	em:RegisterForEvent("SurveyTheWorld", 	EVENT_INVENTORY_SINGLE_SLOT_UPDATE, onSlotUpdate)
end

local function OnAddOnLoaded()
	buildSurveyNameList()	
	registerEvents()
end
STW.OnAddOnLoaded = OnAddOnLoaded

FasterTravel.SurveyTheWorld = STW
