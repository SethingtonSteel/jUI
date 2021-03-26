AUI.Combat = {}
AUI.Combat.Minimeter = {}
AUI.Combat.Statistics = {}
AUI.Combat.Text = {}
AUI.Combat.DamageMeter = {}
AUI.Combat.WeaponChargeWarner = {}

--Combat
AUI_COMBAT_DATA_TYPE_NONE = 1
AUI_COMBAT_DATA_TYPE_DAMAGE_OUT = 2
AUI_COMBAT_DATA_TYPE_HEAL_OUT = 3
AUI_COMBAT_DATA_TYPE_DAMAGE_IN = 4
AUI_COMBAT_DATA_TYPE_HEAL_IN = 5

AUI_COMBAT_DATA_TYPE_DAMAGE = 10
AUI_COMBAT_DATA_TYPE_HEAL = 12

AUI_COMBAT_ANONYMOUS_SOURCE_ID = 0

local MAX_RECORD_COUNT = 30

local g_isInit = false
local gIsRunning = false
local gUltiReady = false
local gPotionReady = false
local gPlayerSourceId = nil
local gPetSourceId = nil
local gCombatStartTimeMS = 0
local gCombatTimeMS = 0
local gNumRecords = 0

local gUnitArray = {}
local gCombatData = {}
local gExperienceData = {}
local gCombatDataArray = {}
local gAbilityProcEffects = {}

local _, gLastHealthValue, _ = GetUnitPower(AUI_PLAYER_UNIT_TAG, POWERTYPE_HEALTH)
local _, gLastMagickaValue, _ = GetUnitPower(AUI_PLAYER_UNIT_TAG, POWERTYPE_MAGICKA)
local _, gLastStaminaValue, _ = GetUnitPower(AUI_PLAYER_UNIT_TAG, POWERTYPE_STAMINA)

local gIsHealthLowActive = false
local gIsMagickaLowActive = false
local gIsStaminaLowActive = false

local gIsPlayer = 
{
	[COMBAT_UNIT_TYPE_PLAYER] 			= true,
}

local gIsPlayerOrPet = 
{
	[COMBAT_UNIT_TYPE_PLAYER] 			= true,
	[COMBAT_UNIT_TYPE_PLAYER_PET] 		= true,
}

local gIsPlayerPet = 
{
	[COMBAT_UNIT_TYPE_PLAYER_PET] 		= true,
}

local gIsGroup = 
{
	[COMBAT_UNIT_TYPE_GROUP] 			= true,
}

local gIsDamage = 
{
	[ACTION_RESULT_DAMAGE] 				= true,
	[ACTION_RESULT_CRITICAL_DAMAGE] 	= true,
	[ACTION_RESULT_DOT_TICK]            = true,
	[ACTION_RESULT_DOT_TICK_CRITICAL]   = true,
	[ACTION_RESULT_FALL_DAMAGE]         = true,
	[ACTION_RESULT_DAMAGE_SHIELDED] 	= true,
	[ACTION_RESULT_BLOCKED_DAMAGE]		= true,
}

local gIsCrit = 
{
	[ACTION_RESULT_CRITICAL_DAMAGE] 	= true,
	[ACTION_RESULT_DOT_TICK_CRITICAL]   = true,
	[ACTION_RESULT_CRITICAL_HEAL]       = true,
	[ACTION_RESULT_HOT_TICK_CRITICAL]   = true,	
}

 local gIsHeal = {
	[ACTION_RESULT_HEAL]                = true,
	[ACTION_RESULT_CRITICAL_HEAL]       = true,
	[ACTION_RESULT_HOT_TICK]            = true,
	[ACTION_RESULT_HOT_TICK_CRITICAL]   = true,	
}

local function IsPlayer(_sourceType)
	if gIsPlayer[_sourceType] then
		return true
	end
	
	return false
end

local function IsPlayerOrPet(_sourceType)
	if gIsPlayerOrPet[_sourceType] then
		return true
	end
	
	return false
end

local function IsPlayerPet(_sourceType)
	if gIsPlayerPet[_sourceType] then
		return true
	end
	
	return false
end

local function IsGroup(_sourceType)
	if gIsGroup[_sourceType] then
		return true
	end
	
	return false
end

local function IsPlayerOrGroup(_sourceType)
	if gIsPlayer[_sourceType] or gIsGroup[_sourceType] then
		return true
	end
	
	return false
end

local function ResetCombatData()
	gCombatData = {}
	gUnitArray = {}

	gCombatTimeMS = 0
	gCombatStartTimeMS = GetGameTimeMilliseconds()
	
	AUI.ResetMiniMeter()
end

local function IsCrit(_result)
	if gIsCrit[_result] then
		return true
	end
	
	return false
end

local function IsAbilitySlotted(_abilityId)
	for slotId = 3, 8 do
		local slotName = GetSlotName(slotId)
		local abilityName = GetAbilityName(_abilityId)
	
		if slotName == abilityName then
			return true	
		end	
	end
	
	return false
end

local function OnUpdateUI()
	AUI.Combat.Minimeter.Update()
end

local function OnUpdateTime()
	gCombatTimeMS = GetGameTimeMilliseconds() - gCombatStartTimeMS
end

local function StopCombatMeter()
	gIsRunning = false

	EVENT_MANAGER:UnregisterForUpdate("AUI_Combat_OnStateUpdate")
	EVENT_MANAGER:UnregisterForUpdate("AUI_Combat_OnUpdateTime")
	EVENT_MANAGER:UnregisterForUpdate("AUI_Combat_OnUpdateUI")	

	local records = {}
	records.data = AUI.Table.Copy(gCombatData)
	records.dateString = GetTimeStamp()
	records.formatedDate = GetDateStringFromTimestamp(GetTimeStamp()) .. " " .. GetTimeString()
	records.combatTime = gCombatTimeMS / 1000
	
	table.insert(gCombatDataArray, records)

	if gNumRecords >= MAX_RECORD_COUNT then
		table.remove(gCombatDataArray, 1)
		gNumRecords = gNumRecords - 1
	end
	
	gNumRecords = gNumRecords + 1
	
	OnUpdateUI()
end

local function StartCombatMeter()
	gIsRunning = true
	
	ResetCombatData()

	EVENT_MANAGER:UnregisterForUpdate("AUI_Combat_OnUpdateTime")	
	EVENT_MANAGER:RegisterForUpdate("AUI_Combat_OnUpdateTime", 0, OnUpdateTime)		
	
	if AUI.Combat.Minimeter.IsEnabled() then
		EVENT_MANAGER:UnregisterForUpdate("AUI_Combat_OnUpdateUI")
		EVENT_MANAGER:RegisterForUpdate("AUI_Combat_OnUpdateUI", 60, OnUpdateUI)
	end
end

function AUI.Combat.GetPlayerSourceId()
	return gPlayerSourceId
end

function AUI.Combat.GetPetSourceId()
	return gPetSourceId
end
	
function AUI.Combat.GetCombatTime()
	return gCombatTimeMS / 1000
end

function AUI.Combat.GetPlayerData()
	return gCombatData[gPlayerSourceId]
end

function AUI.Combat.GetPlayerPetData()
	return gCombatData[gPetSourceId]
end

function AUI.Combat.GetAnonymousData()
	return gCombatData[AUI_COMBAT_ANONYMOUS_SOURCE_ID]
end

function AUI.Combat.GetLastData()
	return gCombatDataArray[gNumRecords]
end

function AUI.Combat.RemoveCombatData(_index)
	for key, data in pairs(gCombatDataArray) do
		if data.dateString == _index then
			table.remove(gCombatDataArray, key)
			gNumRecords = gNumRecords - 1
		end
	end
end

function AUI.Combat.GetNextData(_currentKey)
	table.sort(gCombatDataArray, function(a, b) if a.dateString > b.dateString then return true end end)	

	local lastData = nil
	for key, data in pairs(gCombatDataArray) do
		if data.dateString ~= _currentKey and _currentKey <= data.dateString then
			lastData = data
		end
	end

	return lastData
end

function AUI.Combat.GetPreviousData(_currentKey)
	table.sort(gCombatDataArray, function(a, b) if a.dateString < b.dateString then return true end end)	

	local lastData = nil
	for key, data in pairs(gCombatDataArray) do
		if data.dateString ~= _currentKey and _currentKey >= data.dateString then
			lastData = data
		end
	end

	return lastData
end

local function GetCombatString(_unitData, _type)
	local str = ""
	if _unitData and _unitData.startTimeMS > 0 then	
		local endTimeS =  AUI.Time.MS_To_S(_unitData.endTimeMS)
		local time = 0	

		if endTimeS > 1 then
			time = AUI.Time.GetFormatedString(endTimeS, 1)
		elseif endTimeS > 0.1 then
			time = AUI.Time.GetFormatedString(endTimeS, 2)	
		else
			time = AUI.Time.GetFormatedString(endTimeS, 3)
		end

		local total = _unitData.total
		local avarage = AUI.Combat.CalculateDPS(total, _unitData.endTimeMS)			

		if _type == AUI_COMBAT_DATA_TYPE_DAMAGE_OUT then
			if total > 0 then
				str = str .. "Damage (Out): " .. AUI.String.ToFormatedNumber(total) .. " (" .. time .. ")"
			end
		
			if avarage > 0 then
				str = str .. " - DPS (Out): " .. AUI.String.ToFormatedNumber(avarage)
			end		
		end

		if _type == AUI_COMBAT_DATA_TYPE_DAMAGE_IN then
			if total > 0 then
				str = str .. " - Damage (In): " .. AUI.String.ToFormatedNumber(total) .. " (" .. time .. ")"
			end
		
			if avarage > 0 then
				str = str .. " - DPS (In): " .. AUI.String.ToFormatedNumber(avarage)
			end		
		end			
		
		if _type == AUI_COMBAT_DATA_TYPE_HEAL_OUT then
			if total > 0 then
				str = str .. " - Heal (Out): " .. AUI.String.ToFormatedNumber(total) .. " (" .. time .. ")"
			end

			if avarage > 0 then
				str = str .. " - HPS (Out): " .. AUI.String.ToFormatedNumber(avarage)
			end				
		end				

		if _type == AUI_COMBAT_DATA_TYPE_HEAL_IN then
			if total > 0 then
				str = str .. " - Heal (In): " .. AUI.String.ToFormatedNumber(total) .. " (" .. time .. ")"
			end

			if avarage > 0 then
				str = str .. " - HPS (In): " .. AUI.String.ToFormatedNumber(avarage)
			end				
		end				
	end
	
	return str
end

function AUI.Combat.CheckError()
	local errorString = ""
	local error = false

	if IsUnitInCombat(AUI_PLAYER_UNIT_TAG) then
		errorString = errorString .. AUI.L10n.GetString("waiting_for_combat_end")
		error = true
	elseif not AUI.Table.HasContent(gCombatDataArray) then
		errorString = errorString .. AUI.L10n.GetString("no_records_available")
		error = true
	end

	return error, errorString
end

function AUI.Combat.GetTotalValue(_targetList, _index)
	local value = 0

	if _targetList and _index then
		for targetId, targetData in pairs(_targetList) do
			if targetData and targetData[_index] then
				value = value + targetData[_index]
			end
		end	
	end
	
	return value
end

function AUI.Combat.GetHighestSourceData(_unitData)
	local unitTypeData = nil
	local type = AUI_COMBAT_DATA_TYPE_DAMAGE_OUT

	if _unitData then
		local totalDamage = 0
		local totalheal = 0
		
		if _unitData[AUI_COMBAT_DATA_TYPE_DAMAGE_OUT] then		
			totalDamage = _unitData[AUI_COMBAT_DATA_TYPE_DAMAGE_OUT].total
		end
		
		if _unitData[AUI_COMBAT_DATA_TYPE_HEAL_OUT] then
			totalheal = _unitData[AUI_COMBAT_DATA_TYPE_HEAL_OUT].total
		end
		
		if totalheal > totalDamage then
			type = AUI_COMBAT_DATA_TYPE_HEAL_OUT
		end	
	
		for _, i_unitTypeData in pairs(_unitData) do
			if not unitTypeData or i_unitTypeData[type] and i_unitTypeData[type].total > unitTypeData[type].total then
				unitTypeData = i_unitTypeData
			end
		end
	end
	
	return unitTypeData, type
end

function AUI.Combat.GetHighestPlayerData(_unitData)
	local unitTypeData = nil	
	local type = AUI_COMBAT_DATA_TYPE_DAMAGE_OUT

	if _unitData then
		local playerData = nil
		local playerPetData = nil	
	
		local totalDamage = 0
		local totalheal = 0
		
		if _unitData[AUI_COMBAT_DATA_TYPE_DAMAGE_OUT] then		
			totalDamage = _unitData[AUI_COMBAT_DATA_TYPE_DAMAGE_OUT].total
		end
		
		if _unitData[AUI_COMBAT_DATA_TYPE_HEAL_OUT] then
			totalheal = _unitData[AUI_COMBAT_DATA_TYPE_HEAL_OUT].total
		end
		
		if totalheal > totalDamage then
			type = AUI_COMBAT_DATA_TYPE_HEAL_OUT
		end	
	
		for _, i_unitTypeData in pairs(_unitData) do
			if i_unitTypeData.isPlayer then 
				playerData = i_unitTypeData
				break
			end
		end
				
		for _, i_unitTypeData in pairs(_unitData) do
			if i_unitTypeData.isPlayerPet then 
				playerPetData = i_unitTypeData
				break
			end
		end		
		
		if playerData and playerPetData then
			if playerData[type].total > playerPetData[type].total then
				unitTypeData = playerData
			else
				unitTypeData = playerPetData
			end
		elseif playerData then
			unitTypeData = playerData
		elseif playerPetData then
			unitTypeData = petUnitData
		end
	end

	return unitTypeData, type
end

function AUI.Combat.GetHighestTargetData(_unitData)
	local unitTypeData = nil
	local type = AUI_COMBAT_DATA_TYPE_DAMAGE_OUT
	
	if _unitData then
		local totalDamage = 0
		local totalheal = 0
		
		if _unitData[AUI_COMBAT_DATA_TYPE_DAMAGE_OUT] then
			totalDamage = AUI.Combat.GetTotalValue(_unitData[AUI_COMBAT_DATA_TYPE_DAMAGE_OUT].targets, "total")
		end
		
		if _unitData[AUI_COMBAT_DATA_TYPE_HEAL_OUT] then
			totalheal = AUI.Combat.GetTotalValue(_unitData[AUI_COMBAT_DATA_TYPE_HEAL_OUT].targets, "total")
		end
		
		if totalheal > totalDamage then
			type = AUI_COMBAT_DATA_TYPE_HEAL_OUT
		end

		if _unitData[type].targets then
			for _, i_unitTypeData in pairs(_unitData[type].targets) do
				if not unitTypeData or i_unitTypeData.total > unitTypeData.total then
					unitTypeData = i_unitTypeData
				end
			end
		end
	end	
		
	return unitTypeData, type
end

function AUI.Combat.PostHighestTargetCombatStatistics()
	local sourceUnitData = gCombatData[gPlayerSourceId]
	local error, errorMessage  = AUI.Combat.CheckError()
	
	if error then
		d("AUI-CS: v." .. AUI_COMBAT_VERSION .. " " .. errorMessage)
		return
	end

	local targetUnitData, type = AUI.Combat.GetHighestTargetData(sourceUnitData)
	if sourceUnitData and targetUnitData and type then
		local str = "AUI-CS: v." .. AUI_COMBAT_VERSION .. " | "
		
		str = str .. AUI.String.FirstToUpper(zo_strformat(SI_UNIT_NAME, sourceUnitData.unitName))
		str = str .. " at "
		str = str .. AUI.String.FirstToUpper(zo_strformat(SI_UNIT_NAME, targetUnitData.unitName))
		str = str .. ": "	
		str = str .. GetCombatString(targetUnitData, type)

		StartChatInput(str, CHAT_CHANNEL_PARTY , nil)
	end
end

function AUI.Combat.PostPlayerCombatStatistics()		
	AUI.Combat.PostCombatStatistics(gPlayerSourceId, nil, nil)	
end

function AUI.Combat.PostCombatStatistics(_sourceUnitId, _type, _targetUnitId)
	local str = "AUI-CS: v." .. AUI_COMBAT_VERSION .. " | "
	
	local error, errorMessage  = AUI.Combat.CheckError()
	if error then
		d(str .. errorMessage)
		return
	end		

	local sourceUnitData = gCombatData[_sourceUnitId]
	
	local targetUnitData = nil
	
	if not _targetUnitId or not _type then
		targetUnitData, _type = AUI.Combat.GetHighestTargetData(sourceUnitData)
	elseif _targetUnitId and _type then
		targetUnitData = sourceUnitData[_type].targets[_targetUnitId]
	end
	
	str = str .. zo_strformat(SI_UNIT_NAME, sourceUnitData.unitName)
	str = str .. " at "	

	if _targetUnitId and targetUnitData then 
		str = str .. targetUnitData.unitName
		str = str .. ": "
		str = str .. GetCombatString(targetUnitData, _type)	
	else
		str = str .. "All"
		str = str .. ": "
		str = str .. GetCombatString(sourceUnitData[_type], _type)	
	end	
	
		
	StartChatInput(str, CHAT_CHANNEL_PARTY , nil)
end

function AUI.Combat.CalculateDPS(_totalDamage, _time)
	local average = 0

	if _totalDamage and _time then
		if _time > 0 then
			average = AUI.Math.Round(_totalDamage / (_time / 1000))
		end
	end
	
	if average >= _totalDamage then
		average = _totalDamage
	end
	
	return average
end

function AUI.Combat.CalculateCritPrecent(_totalDamage, _totalCrit)
	return (_totalCrit / _totalDamage) * 100
end

function AUI.Combat.GetTotalAbilityList(_targetList, _petTargetList)
	local abilityList = {}

	for _, targetData in pairs(_targetList) do					
		for abilityId, abilityData in pairs(targetData.abilities) do
			if not abilityList[abilityData.abilityName] then
				abilityList[abilityData.abilityName] = {total = 0, crit = 0, hitCount = 0, abilityId = abilityId, icon = abilityData.icon}
				abilityList[abilityData.abilityName] = abilityList[abilityData.abilityName]
			end
					
			abilityList[abilityData.abilityName].total = abilityList[abilityData.abilityName].total + abilityData.total
			abilityList[abilityData.abilityName].crit = abilityList[abilityData.abilityName].crit + abilityData.crit
			abilityList[abilityData.abilityName].hitCount = abilityList[abilityData.abilityName].hitCount + abilityData.hitCount
		end	
	end		
	
	if _petTargetList then
		for _, targetData in pairs(_petTargetList) do					
			for abilityId, abilityData in pairs(targetData.abilities) do
				if not abilityList[abilityData.abilityName] then
					abilityList[abilityData.abilityName] = {total = 0, crit = 0, hitCount = 0, abilityId = abilityId, icon = abilityData.icon}
					abilityList[abilityData.abilityName] = abilityList[abilityData.abilityName]
				end
						
				abilityList[abilityData.abilityName].total = abilityList[abilityData.abilityName].total + abilityData.total
				abilityList[abilityData.abilityName].crit = abilityList[abilityData.abilityName].crit + abilityData.crit
				abilityList[abilityData.abilityName].hitCount = abilityList[abilityData.abilityName].hitCount + abilityData.hitCount
			end	
		end	
	end
	
	return abilityList
end

local function UpdateData(_value, _isCrit, _data, _ms)
	if _data then
		if _data.endTimeMS then
			_data.endTimeMS = (_ms - _data.startTimeMS)
		end
	
		if _value and _value > 0 then		
			_data.total = _data.total + _value
			if _isCrit then
				_data.crit = _data.crit + _value
			else
				_data.damage = _data.damage + _value
			end
			_data.hitCount = _data.hitCount + 1
		end
	end
end

local function AddData(_sourceUnitId, _sourceType, _targetUnitId, _hitValue, _isCrit, _abilityName, _abilityId, _abilityTexture, _combatType)
	if not _combatType then
		return
	end	
	
	local ms = GetGameTimeMilliseconds()

	if not gCombatData[_sourceUnitId] then	
		gCombatData[_sourceUnitId] = {}	
		gCombatData[_sourceUnitId].sourceUnitId = _sourceUnitId
		gCombatData[_sourceUnitId].startTimeMS  = 0
		gCombatData[_sourceUnitId].endTimeMS = 0
		gCombatData[_sourceUnitId].unitName = AUI.L10n.GetString("unknown")
		
		if IsPlayer(_sourceType) then
			gCombatData[_sourceUnitId].isPlayer = true
		else
			gCombatData[_sourceUnitId].isPlayer = false
		end
		
		if IsPlayerPet(_sourceType) then
			gCombatData[_sourceUnitId].isPlayerPet = true
		else
			gCombatData[_sourceUnitId].isPlayerPet = false
		end				
	end
	
	if not gCombatData[_sourceUnitId][_combatType] then
		gCombatData[_sourceUnitId][_combatType] = {}	
		gCombatData[_sourceUnitId][_combatType].targets = {}	
		gCombatData[_sourceUnitId][_combatType].total = 0
		gCombatData[_sourceUnitId][_combatType].damage = 0
		gCombatData[_sourceUnitId][_combatType].crit = 0
		gCombatData[_sourceUnitId][_combatType].hitCount = 0
		gCombatData[_sourceUnitId][_combatType].startTimeMS = 0
		gCombatData[_sourceUnitId][_combatType].endTimeMS = 0	
	end	

	if gUnitArray[_sourceUnitId] and gUnitArray[_sourceUnitId].unitName	~= gCombatData[_sourceUnitId].unitName then
		gCombatData[_sourceUnitId].unitName = gUnitArray[_sourceUnitId].unitName		
	end	
	
	if not gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId] then
		gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId] = {sourceUnitId = _sourceUnitId, unitName = gUnitArray[_targetUnitId].unitName, total = 0, damage = 0, crit= 0, startTimeMS = ms, endTimeMS = 0, hitCount = 0, targetUnitId = _targetUnitId, isPet = _isPet, abilities = {}}
	end	

	if gCombatData[_sourceUnitId].startTimeMS == 0 then
		gCombatData[_sourceUnitId].startTimeMS = ms
	end	

	if gCombatData[_sourceUnitId][_combatType].startTimeMS == 0 then
		gCombatData[_sourceUnitId][_combatType].startTimeMS = ms
	end	

	UpdateData(_hitValue, _isCrit, gCombatData[_sourceUnitId][_combatType], ms)
	UpdateData(_hitValue, _isCrit, gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId], ms)

	if _abilityId and _abilityTexture then
		if not gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId].abilities[_abilityId] then
			gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId].abilities[_abilityId] = {total = 0, damage = 0, crit= 0, hitCount = 0, abilityName = _abilityName, icon = _abilityTexture}
		end

		if gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId] then
			UpdateData(_hitValue, _isCrit, gCombatData[_sourceUnitId][_combatType].targets[_targetUnitId].abilities[_abilityId], ms)				
		end	
	end
end	

function AUI.Combat.OnCombatEvent(_eventCode, _result, _isError, _abilityName, _abilityGraphic, _abilityActionSlotType, _sourceName, _sourceType, _targetName, _targetType, _hitValue, _powerType, _damageType, _log, _sourceUnitId, _targetUnitId, _abilityId)
	if not g_isInit or _isError or _hitValue <= 0 or not _sourceUnitId or _sourceUnitId < 0 or not _sourceType or not _targetUnitId or _targetUnitId < 0 then
		return
	end		

	if not gPlayerSourceId and IsPlayer(_sourceType) then
		gPlayerSourceId = _sourceUnitId
	end	

	if not gPetSourceId and IsPlayerPet(_sourceType) then
		gPetSourceId = _sourceUnitId
	end	
	
	if not gIsRunning and IsPlayerOrPet(_sourceType) and (gIsDamage[_result] or gIsHeal[_result]) then
		StartCombatMeter()
	end		
	
	if _sourceUnitId == 0 and AUI.String.IsEmpty(_sourceName) then
		_sourceName = AUI.L10n.GetString("anonymous")
	end
	
	if _targetUnitId == 0 and AUI.String.IsEmpty(_targetName) then
		_targetName = AUI.L10n.GetString("anonymous")
	end	
	
	if not gUnitArray[_sourceUnitId] then
		if AUI.String.IsEmpty(_sourceName) then
			_sourceName = AUI.L10n.GetString("unknown" .. " (" .. _sourceUnitId .. ")")
		end
	
		gUnitArray[_sourceUnitId] = 
		{
			["unitName"] = zo_strformat(SI_UNIT_NAME, _sourceName),
		}
	end
	
	if not gUnitArray[_targetUnitId] then
		if AUI.String.IsEmpty(_targetName) then
			_targetName = AUI.L10n.GetString("unknown" .. " (" .. _targetUnitId .. ")")
		end		
	
		gUnitArray[_targetUnitId] = 
		{
			["unitName"] = zo_strformat(SI_UNIT_NAME, _targetName),
		}
	end	

	if not gUnitArray[_sourceUnitId] or not gUnitArray[_targetUnitId] then
		return
	end		
	
	_abilityName = zo_strformat(SI_ABILITY_NAME, GetAbilityName(_abilityId))
	
	if AUI.String.IsEmpty(_abilityName) then
		_abilityName = AUI.L10n.GetString("unknown")
	end			

	if IsPlayerPet(_sourceType) then
		_abilityName = AUI.L10n.GetString("pet") .. ": " .. _abilityName
	end			
	
	if gIsDamage[_result] then	
		local abilityTexture = GetAbilityIcon(_abilityId) or "/esoui/art/icons/icon_missing.dds"
		local isCrit = IsCrit(_result)

		AddData(_sourceUnitId, _sourceType, _targetUnitId, _hitValue, isCrit, _abilityName, _abilityId, abilityTexture, AUI_COMBAT_DATA_TYPE_DAMAGE_OUT)				
		
		if AUI.Combat.Text.IsEnabled() then
			if IsPlayerOrPet(_sourceType) and not IsPlayerOrPet(_targetType) then				
				if isCrit then	
					if AUI.Settings.Combat.scrolling_text_show_critical_damage_out then
						AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_CRIT_DAMAGE_OUT, AUI.Settings.Combat.scrolling_text_damage_out_crit_parent_panelName, abilityTexture, _abilityName)
					end
				elseif AUI.Settings.Combat.scrolling_text_show_damage_out then
					AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_DAMAGE_OUT, AUI.Settings.Combat.scrolling_text_damage_out_parent_panelName, abilityTexture, _abilityName)
				end
			elseif IsPlayerOrPet(_targetType) and not IsPlayerOrPet(_sourceType) then	
				if isCrit then
					if AUI.Settings.Combat.scrolling_text_show_critical_damage_in then
						AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_CRIT_DAMAGE_IN, AUI.Settings.Combat.scrolling_text_damage_in_crit_parent_panelName, abilityTexture, _abilityName)	
					end
				elseif AUI.Settings.Combat.scrolling_text_show_damage_in then
					AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_DAMAGE_IN, AUI.Settings.Combat.scrolling_text_damage_in_parent_panelName, abilityTexture, _abilityName)
				end				
			end
		end
	elseif gIsHeal[_result] then
		local abilityTexture = GetAbilityIcon(_abilityId) or "/esoui/art/icons/icon_missing.dds"
		local isCrit = IsCrit(_result)	
	
		AddData(_sourceUnitId, _sourceType, _targetUnitId, _hitValue, isCrit, _abilityName, _abilityId, abilityTexture, AUI_COMBAT_DATA_TYPE_HEAL_OUT)			

		if AUI.Combat.Text.IsEnabled() then	
			if IsPlayerOrPet(_sourceType) then		
				if isCrit then
					if AUI.Settings.Combat.scrolling_text_show_critical_heal_out then
						AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_CRIT_HEAL_OUT, AUI.Settings.Combat.scrolling_text_heal_out_crit_parent_panelName, abilityTexture, _abilityName)
					end
				elseif AUI.Settings.Combat.scrolling_text_show_heal_out then
					AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_HEAL_OUT, AUI.Settings.Combat.scrolling_text_heal_out_parent_panelName, abilityTexture, _abilityName)
				end	
			elseif IsPlayerOrPet(_targetType)  then
				if isCrit then
					if AUI.Settings.Combat.scrolling_text_show_critical_heal_in then
						AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_CRIT_HEAL_IN, AUI.Settings.Combat.scrolling_text_heal_in_crit_parent_panelName, abilityTexture, _abilityName)
					end
				elseif AUI.Settings.Combat.scrolling_text_show_heal_in then
					AUI.Combat.Text.InsertMessage(_hitValue, AUI_SCROLLING_TEXT_HEAL_IN, AUI.Settings.Combat.scrolling_text_heal_in_parent_panelName, abilityTexture, _abilityName)
				end	
			end		
		end
	end
end

function AUI.Combat.OnPowerUpdate(_unitTag, _powerIndex, _powerType, _powerValue, _powerMax, _powerEffectiveMax)
	if not g_isInit or _unitTag ~= AUI_PLAYER_UNIT_TAG or IsUnitDeadOrReincarnating(_unitTag) then
		return
	end
	
	if _powerType == POWERTYPE_ULTIMATE then
		if AUI.Combat.Text.IsEnabled() and AUI.Settings.Combat.scrolling_text_show_ultimate_ready and _unitTag == AUI_PLAYER_UNIT_TAG then
			local ultimateSlot = GetSlotAbilityCost(8)
			if ultimateSlot > 0 then 
				local unitPercent = AUI.Math.Round((_powerValue / ultimateSlot) * 100)
				if unitPercent >= 100 then			
					if gUltiReady then
						AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("ultimate_ready"), AUI_SCROLLING_TEXT_ULTI_READY, AUI.Settings.Combat.scrolling_text_ultimate_ready_parent_panelName, AUI_SCROLLING_TEXT_ULTIMATE_TEXTURE)
					end			
					gUltiReady = false
				else
					gUltiReady = true
				end
			end		
		end
	elseif _powerType == POWERTYPE_HEALTH then
		local value = _powerValue - gLastHealthValue

		if value > 0 then
			if AUI.Settings.Combat.scrolling_text_show_health_reg then
				AUI.Combat.Text.InsertMessage("+ " .. AUI.String.ToFormatedNumber(value) .. " Health", AUI_SCROLLING_TEXT_HEALTH_REG, AUI.Settings.Combat.scrolling_text_health_reg_parent_panelName, AUI_SCROLLING_TEXT_HEALTH_REG_TEXTURE)
			end
		elseif value < 0 then
			if AUI.Settings.Combat.scrolling_text_show_health_dereg then
				AUI.Combat.Text.InsertMessage("- " .. AUI.String.ToFormatedNumber(value) .. " Health", AUI_SCROLLING_TEXT_HEALTH_DEREG, AUI.Settings.Combat.scrolling_text_health_dereg_parent_panelName, AUI_SCROLLING_TEXT_HEALTH_DEREG_TEXTURE)
			end
		end
		
		local percent = AUI.Math.Round((_powerValue / _powerMax) * 100)
		if percent <= 25 then
			if not gIsHealthLowActive and AUI.Settings.Combat.scrolling_text_show_health_low then
				AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("health_low"), AUI_SCROLLING_TEXT_HEALTH_LOW, AUI.Settings.Combat.scrolling_text_health_low_parent_panelName, AUI_SCROLLING_TEXT_HEALTH_LOW_TEXTURE)
			end	
			gIsHealthLowActive = true	
		else
			gIsHealthLowActive = false	
		end	

		gLastHealthValue = _powerValue
	elseif _powerType == POWERTYPE_MAGICKA then
		local value = _powerValue - gLastMagickaValue
		
		if value > 0 then
			if AUI.Settings.Combat.scrolling_text_show_magicka_reg then
				AUI.Combat.Text.InsertMessage("+ " .. AUI.String.ToFormatedNumber(value) .. " Magicka", AUI_SCROLLING_TEXT_MAGICKA_REG, AUI.Settings.Combat.scrolling_text_magicka_reg_parent_panelName, AUI_SCROLLING_TEXT_MAGICKA_REG_TEXTURE)
			end
		elseif value < 0 then
			if AUI.Settings.Combat.scrolling_text_show_magicka_dereg then
				AUI.Combat.Text.InsertMessage("- " .. AUI.String.ToFormatedNumber(-value) .. " Magicka", AUI_SCROLLING_TEXT_MAGICKA_DEREG, AUI.Settings.Combat.scrolling_text_magicka_dereg_parent_panelName, AUI_SCROLLING_TEXT_MAGICKA_DEREG_TEXTURE)
			end
		end	

		local percent = AUI.Math.Round((_powerValue / _powerMax) * 100)
		if percent <= 25 then
			if not gIsMagickaLowActive and AUI.Settings.Combat.scrolling_text_show_magicka_low then
				AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("magicka_low"), AUI_SCROLLING_TEXT_MAGICKA_LOW, AUI.Settings.Combat.scrolling_text_magicka_low_parent_panelName, AUI_SCROLLING_TEXT_MAGICKA_LOW_TEXTURE)
			end	
			gIsMagickaLowActive = true	
		else
			gIsMagickaLowActive = false				
		end			
		
		gLastMagickaValue = _powerValue		
	elseif _powerType == POWERTYPE_STAMINA then
		local value = _powerValue - gLastStaminaValue
		
		if value > 0 then
			if AUI.Settings.Combat.scrolling_text_show_stamina_reg then
				AUI.Combat.Text.InsertMessage("+ " .. AUI.String.ToFormatedNumber(value) .. " Stamina", AUI_SCROLLING_TEXT_STAMINA_REG, AUI.Settings.Combat.scrolling_text_stamina_reg_parent_panelName, AUI_SCROLLING_TEXT_STAMINA_REG_TEXTURE)
			end
		elseif value < 0 then
			if AUI.Settings.Combat.scrolling_text_show_stamina_dereg then
				AUI.Combat.Text.InsertMessage("- " .. AUI.String.ToFormatedNumber(-value) .. " Stamina", AUI_SCROLLING_TEXT_STAMINA_DEREG, AUI.Settings.Combat.scrolling_text_stamina_dereg_parent_panelName, AUI_SCROLLING_TEXT_STAMINA_DEREG_TEXTURE)
			end
		end	

		local percent = AUI.Math.Round((_powerValue / _powerMax) * 100)
		if percent <= 25 then
			if not gIsStaminaLowActive and AUI.Settings.Combat.scrolling_text_show_stamina_low then
				AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("stamina_low"), AUI_SCROLLING_TEXT_STAMINA_LOW, AUI.Settings.Combat.scrolling_text_stamina_low_parent_panelName, AUI_SCROLLING_TEXT_STAMINA_LOW_TEXTURE)
			end

			gIsStaminaLowActive = true
		elseif gIsStaminaLowActive then
			gIsStaminaLowActive = false				
		end				
		
		gLastStaminaValue = _powerValue
	end
end

function AUI.Combat.OnActionUpdateCooldowns()
	if not g_isInit then
		return
	end

	if AUI.Combat.Text.IsEnabled() then
		if gPotionReady or gPotionReady then
			local currentQuickSlot = GetCurrentQuickslot()
			local _, _, canUse = GetSlotCooldownInfo(currentQuickSlot)
		
			if canUse then	
				AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("potion_ready"), AUI_SCROLLING_TEXT_POTION_READY, AUI.Settings.Combat.scrolling_text_potion_ready_parent_panelName, AUI_SCROLLING_TEXT_POTION_READY_TEXTURE)
				gPotionReady = false
			end
		end
	end
end

function AUI.Combat.OnInventoryItemUsed(_itemSoundCategory)
	if not g_isInit then
		return
	end

	if AUI.Combat.Text.IsEnabled() then
		if _itemSoundCategory == ITEM_SOUND_CATEGORY_POTION then 
			gPotionReady = true
		end
	end
end

function AUI.Combat.OnEffectChanged(_changeType, _effectSlot, _effectName, _unitTag, _beginTime, _endTime, _stackCount, _iconName, _buffType, _effectType, _abilityType, _statusEffectType, _unitName, _unitId, _abilityId)
	if not g_isInit or _unitTag ~= AUI_PLAYER_UNIT_TAG then
		return
	end

	if AUI.Combat.Text.IsEnabled() and IsAbilitySlotted(_abilityId) then
		if _changeType == 1 then
			if AUI.Settings.Combat.scrolling_text_show_instant_casts and AUI.Ability.IsProc(_abilityId) then
				if not gAbilityProcEffects[_abilityId] then
					local effectName = zo_strformat(SI_ABILITY_NAME, _effectName)
					local abilityTexture = GetAbilityIcon(_abilityId) or "/esoui/art/icons/icon_missing.dds"
					AUI.Combat.Text.InsertMessage(effectName, AUI_SCROLLING_TEXT_PROC, AUI.Settings.Combat.scrolling_text_instant_cast_parent_panelName, abilityTexture)
					gAbilityProcEffects[_abilityId] = true
				end
			end
		elseif _changeType == 2 then
			if _abilityType == ABILITY_TYPE_BONUS then
				gAbilityProcEffects[_abilityId] = nil
			end
		end
	end
end

local function UpdateExperienceData()
	gExperienceData.exp = GetUnitXP(AUI_PLAYER_UNIT_TAG)
	gExperienceData.cxp = GetPlayerChampionXP()	
end

function AUI.Combat.OnLevelUpdate()
	UpdateExperienceData()
end

function AUI.Combat.OnExperienceUpdate(_unitTag, _currentExp, _maxExp, _reason)
	if not g_isInit then
		return
	end
	if _unitTag == AUI_PLAYER_UNIT_TAG  then
		local unitData = gCombatData[AUI_PLAYER_UNIT_TAG]
		if gExperienceData then
			if AUI.Settings.Combat.scrolling_text_show_exp then
				local expierence = math.max(_currentExp - gExperienceData.exp, 0)
				if expierence > 0 then
					AUI.Combat.Text.InsertMessage(AUI.String.ToFormatedNumber(expierence) .. " EXP", AUI_SCROLLING_TEXT_EXP, AUI.Settings.Combat.scrolling_text_exp_parent_panelName, AUI_SCROLLING_TEXT_EXP_TEXTURE)
				end
			end
				
			if AUI.Settings.Combat.scrolling_text_show_cxp then
				local currentCxp = GetPlayerChampionXP()
				local cxp = math.max(currentCxp - gExperienceData.cxp, 0)	
				if cxp > 0 then
					local currentCxpAtt = GetChampionPointAttributeForRank(GetPlayerChampionPointsEarned() + 1)
					local iconTexture = "/esoui/art/icons/icon_missing.dds"
					if currentCxpAtt == 1 then
						iconTexture = "/esoui/art/champion/champion_points_health_icon-hud-32.dds"
					elseif currentCxpAtt == 2 then
						iconTexture = "/esoui/art/champion/champion_points_magicka_icon-hud-32.dds"
					elseif currentCxpAtt == 3 then
						iconTexture = "/esoui/art/champion/champion_points_stamina_icon-hud-32.dds"
					end				
				
					AUI.Combat.Text.InsertMessage(AUI.String.ToFormatedNumber(cxp) .. " CXP", AUI_SCROLLING_TEXT_CXP, AUI.Settings.Combat.scrolling_text_cxp_parent_panelName, iconTexture)	
				end
			end
		end
	end
	
	UpdateExperienceData()
end	

function AUI.Combat.OnAlliancePointUpdate(_alliancePoints, _difference)
	if not g_isInit then
		return
	end

	if AUI.Combat.Text.IsEnabled() and AUI.Settings.Combat.scrolling_text_show_ap then
		if _difference > 0 then
			AUI.Combat.Text.InsertMessage(AUI.String.ToFormatedNumber(_difference) .. " AP", AUI_SCROLLING_TEXT_AP, AUI.Settings.Combat.scrolling_text_ap_parent_panelName, AUI_SCROLLING_TEXT_AP_TEXTURE)
		end
	end
end	

function AUI.Combat.OnTelVarStoneUpdate(_newTelvarStones, _oldTelvarStones)
	if not g_isInit then
		return
	end

	if AUI.Combat.Text.IsEnabled() and AUI.Settings.Combat.scrolling_text_show_telvar then
		local difference = _newTelvarStones - _oldTelvarStones
		if difference > 0 then
			AUI.Combat.Text.InsertMessage(AUI.String.ToFormatedNumber(difference) .. " " .. AUI.L10n.GetString("Tel'Var"), AUI_SCROLLING_TEXT_TELVAR, AUI.Settings.Combat.scrolling_text_telvar_parent_panelName, AUI_SCROLLING_TEXT_TELVAR_TEXTURE)
		end
	end
end	

function AUI.Combat.OnPlayerCombatState(_inCombat)
	if not g_isInit then
		return
	end

	if _inCombat == true then
		if AUI.Combat.Text.IsEnabled() and AUI.Settings.Combat.scrolling_text_show_combat_start then
			AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("combat_start"), AUI_SCROLLING_TEXT_COMBAT_START, AUI.Settings.Combat.scrolling_text_combat_start_parent_panelName, AUI_SCROLLING_TEXT_COMBAT_START_TEXTURE)
		end
	elseif _inCombat == false then
		if gIsRunning then
			StopCombatMeter()
		end	
	
		if AUI.Combat.Statistics.DoesShow() then
			AUI.Combat.Statistics.UpdateUI()
		end
		
		if AUI.Combat.Text.IsEnabled() and AUI.Settings.Combat.scrolling_text_show_combat_end then
			AUI.Combat.Text.InsertMessage(AUI.L10n.GetString("combat_end"), AUI_SCROLLING_TEXT_COMBAT_END, AUI.Settings.Combat.scrolling_text_combat_end_panelName, AUI_SCROLLING_TEXT_COMBAT_END_TEXTURE)
		end
		
		if AUI.Combat.WeaponChargeWarner.IsEnabled() then			
			AUI.Combat.WeaponChargeWarner.UpdateAll()
		end			
	end	
end

function AUI.Combat.Load()
	if g_isInit then
		return
	end

	g_isInit = true
	
	local panel1Anchor = {
		point = LEFT,
		relativePoint = LEFT,
		offsetX = 500,
		offsetY = 0	
	}
	
	local panel2Anchor = {
		point = CENTER,
		relativePoint = CENTER,
		offsetX = 0,
		offsetY = 0	
	}	
	
	local panel3Anchor = {
		point = RIGHT,
		relativePoint = RIGHT,
		offsetX = -600,
		offsetY = 0	
	}		
	
	AUI.Combat.Text.AddSctPanel(AUI.L10n.GetString("left"), "panel1", 200, 1000, panel1Anchor, true, AUI_ANIMATION_ECLIPSE, AUI_ANIMATION_MODE_REVERSE_BACKWARD, 3.0)
	AUI.Combat.Text.AddSctPanel(AUI.L10n.GetString("middle"), "panel2", 200, 500, panel2Anchor, true, AUI_ANIMATION_VERTICAL, AUI_ANIMATION_MODE_BACKWARD, 3.0)
	AUI.Combat.Text.AddSctPanel(AUI.L10n.GetString("right"), "panel3", 200, 1000, panel3Anchor, true, AUI_ANIMATION_ECLIPSE, AUI_ANIMATION_MODE_BACKWARD, 3.0)
	
	AUI.Combat.LoadSettings()

	if AUI.Combat.Minimeter.IsEnabled() then	
		AUI.Combat.Minimeter.Load()
	end

	if AUI.Combat.Text.IsEnabled() then	
		AUI.Combat.Text.Load()
	end	

	if AUI.Combat.WeaponChargeWarner.IsEnabled() then	
		AUI.Combat.WeaponChargeWarner.Load()
	end	

	AUI.Combat.Statistics.Load()
	
	UpdateExperienceData()			
end

function AUI.Combat.Minimeter.IsEnabled()
	return AUI.Settings.Combat.minimeter_enabled
end

function AUI.Combat.Text.IsEnabled()
	return AUI.Settings.Combat.scrolling_text_enabled
end

function AUI.Combat.DamageMeter.IsEnabled()
	return AUI.Settings.Combat.damage_meter_enabled
end

function AUI.Combat.WeaponChargeWarner.IsEnabled()
	return AUI.Settings.Combat.weapon_charge_warner_enabled
end