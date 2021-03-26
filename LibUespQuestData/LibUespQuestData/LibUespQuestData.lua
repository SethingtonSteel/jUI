local lib = {}
LibUespQuestData = lib

lib.quests = {}
lib.questNames = uespQuestNames

local function OnLoad(_, addonName)
	if (addonName ~= "LibUespQuestData") then return end
	EVENT_MANAGER:UnregisterForEvent("LibUespQuestData", EVENT_ADD_ON_LOADED)
	for n=1,#uespQuestData do
		for k,v in pairs(uespQuestData[n]) do
			if k=="internalId" then lib.quests[tonumber(v)]=uespQuestData[n]
			end
		end
	end
	for n=1,#uespQuestData2 do
		for k,v in pairs(uespQuestData2[n]) do
			if k=="internalId" then lib.quests[tonumber(v)]=uespQuestData2[n]
			end
		end
	end
	uespQuestData = {}
	uespQuestData2 = {}
	uespQuestNames = {}
	for k, v in pairs(lib.quests) do
		-- replace zone name with ID
		n = uespZoneNameToID[v["zone"]]
		if n then
			lib.quests[k]["zone"] = n
		end
		str = uespZoneNames[v["zone"]]
		if n then
			lib.quests[k]["zone"] = str
		end
	end
	uespZoneNameToID = {}
	uespZoneNames = {}

end


EVENT_MANAGER:RegisterForEvent("LibUespQuestData", EVENT_ADD_ON_LOADED, OnLoad)


function lib:GetUespQuestInfo(questId)
	local name
	local questType
	local zoneName
	local objectiveName
	if lib.quests[questId] == nil then
		name = ""
		questType = 0
		zoneName = ""
		objectiveName = ""
	else
		name = lib.questNames[questId]
		questType = tonumber(lib.quests[questId]["type"])
		zoneName = lib.quests[questId]["zone"]
		objectiveName = lib.quests[questId]["objective"]
	end
	return name, questType, zoneName, objectiveName
end

function lib:GetUespQuestName(questId)
	local name
	if lib.quests[questId] == nil then
		name = ""
	else
		name = lib.questNames[questId]
	end
	return name
end

function lib:GetUespQuestType(questId)
	local questType
	if lib.quests[questId] == nil then
		questType = 0
	else
		questType = tonumber(lib.quests[questId]["type"])
	end
	return questType
end

function lib:GetUespQuestLocationInfo(questId)
	local zoneName
	local objectiveName
	local poiIndex
	if lib.quests[questId] == nil then
		zoneName = ""
		objectiveName = ""
		poiIndex = 0
	else
		zoneName = lib.quests[questId]["zone"]
		objectiveName = lib.quests[questId]["objective"]
		poiIndex = tonumber(lib.quests[questId]["poiIndex"])
	end
	return zoneName, objectiveName, poiIndex
end

function lib:GetUespQuestBackgroundText(questId)
	local backgroundText
	if lib.quests[questId] == nil then
		backgroundText = ""
	else
		backgroundText = lib.quests[questId]["backgroundText"]
	end
	return backgroundText
end

function lib:GetIsUespQuestSharable(questId)
	local isSharable
	if lib.quests[questId] == nil then
		isSharable = nil
	else
		if lib.quests[questId]["isShareable"] == "1" then
			isSharable = true
		elseif lib.quests[questId]["isShareable"] == "0" then
			isSharable = false
		else
			isSharable = nil
		end
	end
	return isSharable
end

function lib:GetUespQuestInstanceDisplayType(questId)
	local instanceDisplayType
	if lib.quests[questId] == nil then
		instanceDisplayType = 0
	else
		instanceDisplayType = tonumber(lib.quests[questId]["displayType"])
	end
	return instanceDisplayType
end

function lib:GetUespQuestRepeatType(questId)
	local repeatType
	if lib.quests[questId] == nil then
		repeatType = 0
	else
		repeatType = tonumber(lib.quests[questId]["repeatType"])
	end
	return repeatType
end
